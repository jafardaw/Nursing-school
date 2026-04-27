import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/utils/validators.dart';

import 'package:responsive_framework/responsive_framework.dart';

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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: styles.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: isDesktop ? 450 : double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: styles.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: styles.shadowColor,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  showWebBanner(
                    context,
                    state.user.baseResponse.message,
                    type: BannerType.success,
                  );

                  NavigationService.pushTo(context, AppRoutes.homerout);
                  // 🟢 نجاح → اذهب للرئيسية
                } else if (state is AuthError) {
                  showWebBanner(context, state.message, type: BannerType.error);
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🟢 عنوان
                      Icon(
                        Icons.local_hospital_rounded,
                        size: 64,
                        color: styles.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text('تسجيل الدخول', style: styles.headline3),
                      const SizedBox(height: 8),
                      Text('أدخل بياناتك للمتابعة', style: styles.bodySmall),
                      const SizedBox(height: 32),
                      CustomeTextField(
                        controller: _emailController,
                        enabled: !isLoading,
                        validator: Validators.email,
                        hintStyle: styles.bodyLarge,
                        labelStyle: styles.bodyLarge,
                        keyboardType: TextInputType.emailAddress,

                        labelText: 'البريد الإلكتروني',
                        hintText: 'example@email.com',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: styles.textHintColor,
                        ),
                      ),

                      const SizedBox(height: 16),
                      CustomeTextField(
                        controller: _passwordController,
                        enabled: !isLoading,
                        obscureText: true,
                        validator: (v) => Validators.password(v),
                        hintStyle: styles.bodyLarge,
                        labelStyle: styles.bodyLarge,
                        labelText: 'كلمة المرور',
                        hintText: '***********',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),

                      // 🟢 كلمة مرور
                      const SizedBox(height: 24),
                      CustomButton(
                        onTap: () {
                          isLoading ? null : _handleLogin();
                        },
                        text: 'تسجيل الدخول',
                        isLoading: isLoading,
                        icon: Icons.login_outlined,
                      ),

                      // 🟢 زر تسجيل الدخول
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
