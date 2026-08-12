import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── Models ──────────────────────────────────────────────────────────────────
class _ScanResult {
  final String firstName;
  final String lastName;
  final String direction;
  final bool isLate;
  final bool violation;
  final int logId;
  final DateTime time;

  _ScanResult({
    required this.firstName,
    required this.lastName,
    required this.direction,
    required this.isLate,
    required this.violation,
    required this.logId,
    required this.time,
  });

  String get fullName => '$firstName $lastName';
  bool get isIn => direction.toLowerCase() == 'in';
}

class _LogEntry {
  final _ScanResult? result;
  final String? errorMsg;
  final DateTime time;

  _LogEntry.success(this.result) : errorMsg = null, time = DateTime.now();
  _LogEntry.error(this.errorMsg) : result = null, time = DateTime.now();
}

enum _ScreenState { waiting, loading, success, error }

// ─────────────────────────────────────────────────────────────────────────────

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  _ScanResult? _lastResult;
  String _statusMsg = '';
  _ScreenState _screenState = _ScreenState.waiting;
  final List<_LogEntry> _logs = [];
  bool _disposed = false;

  late AnimationController _pulseCtrl;
  late AnimationController _cardCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _cardAnim;

  static const String _bridgeUrl = 'http://localhost:5000';
  static const String _apiUrl =
      'https://nursing-school-app-eybnf8hwa0hhavcg.swedencentral-01.azurewebsites.net/api';

  // الألوان الثابتة للتصميم
  static const Color _bg = Color(0xFF0D1117);
  static const Color _surface = Color(0xFF161B22);
  static const Color _panelBorder = Color(0xFF30363D);
  static const Color _accent = Color(0xFF58A6FF);

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnim = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _cardAnim = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutBack);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scanFingerprint());
  }

  @override
  void dispose() {
    _disposed = true;
    _pulseCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  // ─── Bridge ──────────────────────────────────────────────────────────────
  Future<void> _scanFingerprint() async {
    if (_disposed) return;
    _safeSetState(() {
      _screenState = _ScreenState.waiting;
      _statusMsg = '';
      _lastResult = null;
    });
    try {
      final response = await http
          .get(
            Uri.parse('$_bridgeUrl/scan'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (_disposed) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final rawId = data['fingerprint_id'];
        if (rawId != null) {
          await _sendAttendance(rawId.toString());
          return;
        }
      }
      _scheduleNextScan(seconds: 1);
    } on TimeoutException {
      _scheduleNextScan(seconds: 0);
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('xmlhttprequest') ||
          errStr.contains('cors') ||
          errStr.contains('failed to fetch') ||
          errStr.contains('clientexception')) {
        _safeSetState(() {
          _screenState = _ScreenState.error;
          _statusMsg = 'خطأ CORS\nشغّل Bridge مع:\n--disable-web-security';
        });
        return;
      }
      _safeSetState(() {
        _screenState = _ScreenState.error;
        _statusMsg = 'Bridge غير متاح\nتأكد من تشغيل FingerprintBridge.exe';
      });
      _scheduleNextScan(seconds: 3);
    }
  }

  Future<void> _sendAttendance(String fingerprintId) async {
    if (_disposed) return;
    _safeSetState(() {
      _screenState = _ScreenState.loading;
      _statusMsg = '';
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final bodyStr = jsonEncode({
        'fingerprint_id': fingerprintId,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      });
      final response = await http
          .post(
            Uri.parse('$_apiUrl/gate/scan/in'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            body: bodyStr,
          )
          .timeout(const Duration(seconds: 30));
      if (_disposed) return;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final d = json['data'] as Map<String, dynamic>? ?? {};
        final s = d['student'] as Map<String, dynamic>? ?? {};
        final result = _ScanResult(
          firstName: s['first_name']?.toString() ?? '',
          lastName: s['last_name']?.toString() ?? '',
          direction: d['direction']?.toString() ?? 'In',
          isLate: d['is_late'] == true,
          violation: d['violation'] == true,
          logId: (d['log_id'] as num?)?.toInt() ?? 0,
          time: DateTime.now(),
        );
        _safeSetState(() {
          _lastResult = result;
          _screenState = _ScreenState.success;
        });
        _cardCtrl.forward(from: 0);
        _logs.insert(0, _LogEntry.success(result));
      } else {
        final msg =
            json['message'] ?? json['error'] ?? 'خطأ ${response.statusCode}';
        _safeSetState(() {
          _screenState = _ScreenState.error;
          _statusMsg = msg.toString();
        });
        _logs.insert(0, _LogEntry.error(msg.toString()));
      }
    } catch (e) {
      _safeSetState(() {
        _screenState = _ScreenState.error;
        _statusMsg = 'خطأ في الاتصال بالـ Backend';
      });
      _logs.insert(0, _LogEntry.error('خطأ شبكة'));
    }
    _scheduleNextScan(seconds: 3);
  }

  void _scheduleNextScan({int seconds = 1}) {
    if (_disposed) return;
    Future.delayed(Duration(seconds: seconds), () {
      if (!_disposed) _scanFingerprint();
    });
  }

  void _safeSetState(VoidCallback fn) {
    if (!_disposed && mounted) setState(fn);
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime t) {
    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${t.day} ${months[t.month]}';
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Row(
                children: [
                  // ─── اليسار: البصمة ────────────────────────────────────
                  Expanded(flex: 3, child: _buildFingerprintPanel()),

                  // ─── الفاصل ────────────────────────────────────────────
                  Container(width: 1, color: _panelBorder),

                  // ─── اليمين: السجل ─────────────────────────────────────
                  Expanded(flex: 2, child: _buildLogPanel()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TopBar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    final now = DateTime.now();
    final dotColor = switch (_screenState) {
      _ScreenState.waiting => _accent,
      _ScreenState.loading => Colors.amber,
      _ScreenState.success => Colors.green,
      _ScreenState.error => Colors.red,
    };
    final dotLabel = switch (_screenState) {
      _ScreenState.waiting => 'في انتظار البصمة',
      _ScreenState.loading => 'جاري التحقق...',
      _ScreenState.success => 'تم بنجاح',
      _ScreenState.error => 'خطأ',
    };

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _panelBorder)),
      ),
      child: Row(
        children: [
          // أيقونة + العنوان
          const Icon(Icons.fingerprint, color: _accent, size: 22),
          const SizedBox(width: 10),
          const Text(
            'نظام الدخول والخروج',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.3,
            ),
          ),

          const Spacer(),

          // حالة النظام
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: dotColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dotColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  dotLabel,
                  style: TextStyle(
                    color: dotColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // التاريخ والوقت
          Text(
            '${_formatDate(now)}  •  ${_formatTime(now)}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ─── Panel البصمة (يسار) ──────────────────────────────────────────────────
  Widget _buildFingerprintPanel() {
    return Container(
      color: _bg,
      child: switch (_screenState) {
        _ScreenState.waiting => _buildWaitingView(),
        _ScreenState.loading => _buildLoadingView(),
        _ScreenState.success => _buildSuccessView(),
        _ScreenState.error => _buildErrorView(),
      },
    );
  }

  Widget _buildWaitingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnim,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _accent.withValues(alpha: 0.15),
                    _accent.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: const Icon(Icons.fingerprint, size: 120, color: _accent),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'ضع إصبعك على الجهاز',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'في انتظار البصمة...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              color: _accent,
              strokeWidth: 3,
              backgroundColor: _accent.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'جاري التحقق من البصمة...',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    final r = _lastResult!;
    final dirColor = r.isIn ? const Color(0xFF3FB950) : const Color(0xFFF78166);
    final dirIcon = r.isIn ? Icons.login_rounded : Icons.logout_rounded;
    final dirLabel = r.isIn ? 'دخول' : 'خروج';

    return Center(
      child: ScaleTransition(
        scale: _cardAnim,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: dirColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: dirColor.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pill(dirIcon, dirLabel, dirColor),
                    Text(
                      _formatTime(r.time),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Fingerprint icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3FB950).withValues(alpha: 0.1),
                    border: Border.all(
                      color: const Color(0xFF3FB950).withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: Color(0xFF3FB950),
                    size: 54,
                  ),
                ),
                const SizedBox(height: 20),

                // Student name
                Text(
                  r.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'تم تسجيل الـ $dirLabel بنجاح ✅',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),
                Divider(color: Colors.white.withValues(alpha: 0.08)),
                const SizedBox(height: 20),

                // Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _badge(
                      Icons.access_time_rounded,
                      r.isLate ? 'متأخر' : 'في الوقت',
                      r.isLate
                          ? const Color(0xFFD29922)
                          : const Color(0xFF3FB950),
                    ),
                    _badge(
                      Icons.warning_amber_rounded,
                      r.violation ? 'مخالفة' : 'لا مخالفة',
                      r.violation
                          ? const Color(0xFFF78166)
                          : const Color(0xFF3FB950),
                    ),
                    _badge(Icons.tag_rounded, '#${r.logId}', _accent),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _statusMsg,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 15,
                height: 1.7,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Panel السجل (يمين) ───────────────────────────────────────────────────
  Widget _buildLogPanel() {
    return Container(
      color: _surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _panelBorder)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _scanFingerprint();
                  },
                  icon: Icon(Icons.history_rounded, size: 18),
                  color: Colors.white38,
                ),
                const SizedBox(width: 8),
                const Text(
                  'سجل العمليات',
                  style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (_logs.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_logs.length}',
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          color: Colors.white.withValues(alpha: 0.1),
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد عمليات بعد',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.2),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _logs.length,
                    itemBuilder: (ctx, i) => _buildLogItem(_logs[i], i),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(_LogEntry entry, int index) {
    if (entry.result == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.errorMsg ?? 'خطأ',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
            Text(
              _formatTime(entry.time),
              style: const TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
      );
    }

    final r = entry.result!;
    final dirColor = r.isIn ? const Color(0xFF3FB950) : const Color(0xFFF78166);
    final isFirst = index == 0;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isFirst
              ? dirColor.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFirst
                ? dirColor.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dirColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                r.isIn ? Icons.login_rounded : Icons.logout_rounded,
                color: dirColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        r.isIn ? 'دخول' : 'خروج',
                        style: TextStyle(color: dirColor, fontSize: 11),
                      ),
                      if (r.isLate) ...[
                        const Text(
                          ' · ',
                          style: TextStyle(color: Colors.white24, fontSize: 11),
                        ),
                        const Text(
                          'متأخر',
                          style: TextStyle(
                            color: Color(0xFFD29922),
                            fontSize: 11,
                          ),
                        ),
                      ],
                      if (r.violation) ...[
                        const Text(
                          ' · ',
                          style: TextStyle(color: Colors.white24, fontSize: 11),
                        ),
                        const Text(
                          'مخالفة',
                          style: TextStyle(
                            color: Color(0xFFF78166),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(r.time),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '#${r.logId}',
                  style: const TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Widget _pill(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
