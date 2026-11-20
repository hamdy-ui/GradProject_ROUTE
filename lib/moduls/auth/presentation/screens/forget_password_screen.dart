import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit.create(),
      child: const _ForgetPasswordScreenBody(),
    );
  }
}

class _ForgetPasswordScreenBody extends StatefulWidget {
  const _ForgetPasswordScreenBody();

  @override
  State<_ForgetPasswordScreenBody> createState() =>
      _ForgetPasswordScreenBodyState();
}

class _ForgetPasswordScreenBodyState extends State<_ForgetPasswordScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onVerifyEmailPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context
          .read<AuthCubit>()
          .sendPasswordResetEmail(email: _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetSentState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.surfaceDark,
                  content: Text(
                    state.message,
                    style: AppStyles.font14WhiteRegular,
                  ),
                ),
              );
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.surfaceDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    'Email Sent',
                    style: AppStyles.font20PrimaryBold,
                  ),
                  content: Text(
                    state.message,
                    style: AppStyles.font14WhiteRegular,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: AppStyles.font16PrimarySemiBold,
                      ),
                    ),
                  ],
                ),
              );
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

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Forget Password',
                            style: AppStyles.font20PrimaryBold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          verticalSpace(20),
                          // Illustration
                          Center(
                            child: Image.asset(
                              AppAssets.forgotPasswordIllustration,
                              width: double.infinity,
                              height: 320,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(
                                height: 260,
                                child: Icon(
                                  Icons.lock_reset,
                                  size: 100,
                                  color: AppColors.primary,
                                ),
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
                          verticalSpace(28),
                          // Verify Email Button
                          CustomButton(
                            text: 'Verify Email',
                            isLoading: isLoading,
                            onPressed: () => _onVerifyEmailPressed(context),
                          ),
                          verticalSpace(24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}