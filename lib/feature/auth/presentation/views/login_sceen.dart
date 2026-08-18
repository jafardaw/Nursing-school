import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:finalproject/core/widgets/stethoscope_icon.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/utils/validators.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  void initState() {
    getToken();
    // FirebaseMessaging.onMessage.listen(showflutternoti);
    super.initState();
  }

  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    StorageServiceImpl storageService = StorageServiceImpl(await SharedPreferences.getInstance());
    await storageService.saveString('fcm_token', token ?? '');
    debugPrint("--- FCM WEB TOKEN ---");
    debugPrint(token);
  }

  // void showflutternoti(RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;

  //   debugPrint('--- FCM Message Received ---');
  //   debugPrint('Title: ${notification?.title}');
  //   debugPrint('Body: ${notification?.body}');
  //   debugPrint('Data: ${message.data}');
  //   if (notification != null && mounted) {
  //     showWebBanner(
  //       context,
  //       '${notification.title}: ${notification.body}',
  //       type: BannerType.info,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFF070913),
      body: Stack(
        children: [
          // 🟢 خلفية الإضاءة البصرية المتوهجة
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7).withValues(alpha: 0.18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF0284C7),
                    blurRadius: 180,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: 0.18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF6366F1),
                    blurRadius: 180,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),

          // 🟢 محتوى الصفحة الرئيسي
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 20,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1080 : 480,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 🟢 الجانب الأيمن: البنر البصري 3D (يظهر في Desktop/Web)
                      if (isDesktop)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(48),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0284C7).withValues(alpha: 0.25),
                                  const Color(0xFF6366F1).withValues(alpha: 0.25),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              border: Border(
                                left: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0284C7), Color(0xFF6366F1)],
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0284C7).withValues(alpha: 0.45),
                                        blurRadius: 28,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const StethoscopeIconWidget(
                                    size: 44,
                                    color: Colors.white,
                                  ),
                                ).animate(
                                  onPlay: (controller) => controller.repeat(reverse: true),
                                ).scale(
                                  duration: 1400.ms,
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.1, 1.1),
                                  curve: Curves.easeInOut,
                                ).shimmer(
                                  duration: 2200.ms,
                                  color: Colors.white.withValues(alpha: 0.35),
                                ),
                                const SizedBox(height: 28),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 4,
                                        backgroundColor: Color(0xFF34D399),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "المنظومة الرقمية الموحدة 2026",
                                        style: TextStyle(
                                          color: Color(0xFF34D399),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'أتمتة مدرسة وكلية التمريض',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'منظومة موحدة تربط بين الإدارة العامة، شؤون الطالبات، الامتحانات، المستشفيات، السكن الجامعي، والصيانة والمستودع.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF94A3B8),
                                    height: 1.7,
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // بطاقات المصداقية
                                _buildFeatureRow(
                                  Icons.verified_user_rounded,
                                  'حماية وتشفير عالي المستويات',
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureRow(
                                  Icons.speed_rounded,
                                  'سرعة واستجابة فائقة لكل الإدارات',
                                ),
                                const SizedBox(height: 12),
                                _buildFeatureRow(
                                  Icons.notifications_active_rounded,
                                  'تنبيهات فورية ومباشرة للعمليات',
                                ),
                              ],
                            ),
                          ),
                        ),

                      // 🟢 الجانب الأيسر: نموذج الدخول (Form Card)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(isDesktop ? 48 : 28),
                          child: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthAuthenticated) {
                                showWebBanner(
                                  context,
                                  state.user.baseResponse.message,
                                  type: BannerType.success,
                                );

                                // توجيه مباشر حسب الـ role
                                final role = state.user.role;
                                if (role == 'entry_exit_supervisor') {
                                  NavigationService.pushTo(
                                    context,
                                    AppRoutes.attendanceRoute,
                                  );
                                } else {
                                  NavigationService.pushTo(
                                    context,
                                    AppRoutes.homerout,
                                  );
                                }
                              } else if (state is AuthError) {
                                showWebBanner(
                                  context,
                                  state.message,
                                  type: BannerType.error,
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;

                              return Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isDesktop) ...[
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF0284C7),
                                                Color(0xFF6366F1),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF0284C7)
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 20,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: const StethoscopeIconWidget(
                                            size: 38,
                                            color: Colors.white,
                                          ),
                                        ).animate(
                                          onPlay: (controller) => controller.repeat(reverse: true),
                                        ).scale(
                                          duration: 1400.ms,
                                          begin: const Offset(1, 1),
                                          end: const Offset(1.1, 1.1),
                                          curve: Curves.easeInOut,
                                        ).shimmer(
                                          duration: 2200.ms,
                                          color: Colors.white.withValues(alpha: 0.35),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],

                                    const Text(
                                      'تسجيل الدخول للنظام 🔐',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'أدخل بيانات حسابك الوظيفي للمتابعة',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // 🟢 البريد الإلكتروني
                                    CustomeTextField(
                                      controller: _emailController,
                                      enabled: !isLoading,
                                      validator: Validators.email,
                                      hintStyle: styles.bodyLarge.copyWith(
                                        color: const Color(0xFF64748B),
                                      ),
                                      labelStyle: styles.bodyLarge.copyWith(
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      labelText: 'البريد الإلكتروني',
                                      hintText: 'example@email.com',
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // 🟢 كلمة المرور
                                    CustomeTextField(
                                      controller: _passwordController,
                                      enabled: !isLoading,
                                      obscureText: true,
                                      validator: (v) => Validators.password(v),
                                      hintStyle: styles.bodyLarge.copyWith(
                                        color: const Color(0xFF64748B),
                                      ),
                                      labelStyle: styles.bodyLarge.copyWith(
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      labelText: 'كلمة المرور',
                                      hintText: '***********',
                                      prefixIcon: const Icon(
                                        Icons.lock_outlined,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // 🟢 زر الدخول
                                    CustomButton(
                                      onTap: () {
                                        isLoading ? null : _handleLogin();
                                      },
                                      text: 'تسجيل الدخول للنظام',
                                      isLoading: isLoading,
                                      icon: Icons.login_outlined,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF38BDF8)),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
