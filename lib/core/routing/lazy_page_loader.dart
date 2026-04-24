import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// ويدجت ذكي للتحميل المؤجل مع Skeleton UI
class LazyPageLoader extends StatelessWidget {
  final Future<void> Function() loadLibrary;
  final Widget Function() builder;
  
  const LazyPageLoader({
    super.key,
    required this.loadLibrary,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    return _LazyPageBody(
      loadLibrary: loadLibrary,
      builder: builder,
    );
  }
}

class _LazyPageBody extends StatefulWidget {
  final Future<void> Function() loadLibrary;
  final Widget Function() builder;
  
  const _LazyPageBody({
    required this.loadLibrary,
    required this.builder,
  });
  
  @override
  State<_LazyPageBody> createState() => _LazyPageBodyState();
}

class _LazyPageBodyState extends State<_LazyPageBody> {
  late Future<bool> _loadFuture;
  
  @override
  void initState() {
    super.initState();
    _loadFuture = _loadLibrarySafely();
  }
  
  Future<bool> _loadLibrarySafely() async {
    try {
      await widget.loadLibrary();
      return true;
    } catch (e) {
      debugPrint('خطأ في التحميل المؤجل: $e');
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadFuture,
      builder: (context, snapshot) {
        // اكتمل التحميل بنجاح
        if (snapshot.connectionState == ConnectionState.done && 
            snapshot.hasData && 
            snapshot.data == true) {
          return widget.builder();
        }
        
        // خطأ في التحميل
        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error.toString());
        }
        
        // جاري التحميل - Skeleton UI
        return _buildLoadingSkeleton();
      },
    );
  }
  
  Widget _buildLoadingSkeleton() {
    return Scaffold(
      body: Skeletonizer(
        enabled: true,
        child: CustomScrollView(
          slivers: [
            // AppBar وهمي
            SliverAppBar(
              title: Bone.text(words: 2),
              expandedHeight: 200,
              flexibleSpace: const FlexibleSpaceBar(),
            ),
            // محتوى وهمي
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.text(words: 4),
                          const SizedBox(height: 8),
                          Bone.text(words: 10),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Bone.circle(size: 40),
                              const SizedBox(width: 12),
                              Expanded(child: Bone.text()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                childCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildErrorPage(String error) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('فشل تحميل الصفحة', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _loadFuture = _loadLibrarySafely();
                });
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}