import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
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
          return ShowErrorWidgetView(errorMessage: snapshot.error.toString());
       
        }
        
        // جاري التحميل - Skeleton UI
        return buildLoadingSkeleton();
      },
    );
  }
  

  

}