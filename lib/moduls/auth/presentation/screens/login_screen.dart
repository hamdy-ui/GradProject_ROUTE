import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/language_switcher_widget.dart';
import '../widgets/or_divider_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit.create(),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().loginWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  void _onGoogleLoginPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.surfaceDark,
                  content: Text(
                    'Welcome back, ${state.user.name}!',
                    style: AppStyles.font14WhiteRegular,
                  ),
                ),
              );
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text(
                    state.errorMessage,
                    style: AppStyles.font14WhiteRegular,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      verticalSpace(20),
                      // App Logo
                      Center(
                        child: Image.asset(
                          AppAssets.loginLogo,
                          width: 120,
                          height: 118,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            AppAssets.logo,
                            width: 120,
                            height: 118,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      verticalSpace(36),
                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.emailIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16),
                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.lockIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Image.asset(
                            AppAssets.eyeOffIcon,
                            width: 30,
                            height: 30,
                            color: _obscurePassword
                                ? AppColors.grey.withValues(alpha: 60)
                                : AppColors.primary.withValues(alpha: 60),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      verticalSpace(12),
                      // Forget Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.forgetPassword,
                            );
                          },
                          child: const Text(
                            'Forget Password ?',
                            style: AppStyles.font14PrimaryRegular,
                          ),
                        ),
                      ),
                      verticalSpace(28),
                      // Login Button
                      CustomButton(
                        text: 'Login',
                        isLoading: isLoading,
                        onPressed: () => _onLoginPressed(context),
                      ),
                      verticalSpace(20),
                      // Don't Have Account ? Create One
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don’t Have Account ? ',
                                  style: AppStyles.font14WhiteRegular,
                                ),
                                TextSpan(
                                  text: 'Create One',
                                  style: AppStyles.font14PrimaryBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(24),
                      // OR Divider
                      const OrDividerWidget(),
                      verticalSpace(24),
                      // Login With Google Button
                      CustomButton(
                        text: 'Login With Google',
                        isLoading: isLoading,
                        prefixIcon: Image.asset(
                          AppAssets.googleIcon,
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () => _onGoogleLoginPressed(context),
                      ),
                      verticalSpace(32),
                      // Language Switcher
                      const Center(
                        child: LanguageSwitcherWidget(),
                      ),
                      verticalSpace(16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
