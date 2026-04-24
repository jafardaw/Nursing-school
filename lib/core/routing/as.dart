import 'package:finalproject/core/services/navigation_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: // في HomeScreen
        ElevatedButton(
          onPressed: () {
            NavigationService().pushTo(context, '/products');
          },
          child: const Text('عرض المنتجات'),
        ),
      ),
    );
  }
}
