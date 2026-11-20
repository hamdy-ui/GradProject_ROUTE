import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';
import '../widgets/avatar_selection_sheet.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit.create()..loadProfileData(),
      child: const _UpdateProfileBody(),
    );
  }
}

class _UpdateProfileBody extends StatefulWidget {
  const _UpdateProfileBody();

  @override
  State<_UpdateProfileBody> createState() => _UpdateProfileBodyState();
}

class _UpdateProfileBodyState extends State<_UpdateProfileBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  int _selectedAvatarIndex = 0;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AvatarSelectionSheet(
        selectedIndex: _selectedAvatarIndex,
        onSelected: (index) {
          setState(() {
            _selectedAvatarIndex = index;
          });
        },
      ),
    );
  }

  void _onResetPasswordPressed() {
    context.read<ProfileCubit>().sendPasswordReset();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary,
        content: Text('Password reset email has been sent!'),
      ),
    );
  }

  void _onDeleteAccountPressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account', style: AppStyles.font20PrimaryBold),
        content: const Text(
          'Are you sure you want to permanently delete your account and all associated data? This action cannot be undone.',
          style: AppStyles.font14WhiteRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<ProfileCubit>().deleteAccount();
    }
  }

  void _onUpdateDataPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<ProfileCubit>().updateProfile(
        name: _nameController.text,
        phone: _phoneController.text,
        avatarIndex: _selectedAvatarIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primary,
                  content: Text(state.message),
                ),
              );
              Navigator.pop(context);
            } else if (state is ProfileAccountDeletedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text('Account deleted successfully'),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route) => false,
              );
            } else if (state is ProfileErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text(state.message),
                ),
              );
            } else if (state is ProfileLoadedState && !_isInitialized) {
              _isInitialized = true;
              final user = state.user;
              if (user != null) {
                _nameController.text = user.name;
                _phoneController.text = user.phone;
                _selectedAvatarIndex = user.avatarIndex;
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is ProfileLoadingState;
            final avatarAsset = (_selectedAvatarIndex >= 0 &&
                _selectedAvatarIndex < AppAssets.allAvatars.length)
                ? AppAssets.allAvatars[_selectedAvatarIndex]
                : AppAssets.avatar1;

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
                            'Pick Avatar',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          verticalSpace(16),
                          // Avatar Display (tappable)
                          Center(
                            child: GestureDetector(
                              onTap: _showAvatarPicker,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        avatarAsset,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          verticalSpace(32),
                          // Name Field
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Name',
                            keyboardType: TextInputType.name,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Image.asset(
                                AppAssets.idIcon,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          verticalSpace(16),
                          // Phone Number Field
                          CustomTextField(
                            controller: _phoneController,
                            hintText: 'Phone Number',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Image.asset(
                                AppAssets.phoneIcon,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          verticalSpace(20),
                          // Reset Password Link
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _onResetPasswordPressed,
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          verticalSpace(60),
                          // Delete Account Button
                          CustomButton(
                            text: 'Delete Account',
                            backgroundColor: AppColors.redButton,
                            textColor: AppColors.white,
                            isLoading: isLoading,
                            onPressed: _onDeleteAccountPressed,
                          ),
                          verticalSpace(16),
                          // Update Data Button
                          CustomButton(
                            text: 'Update Data',
                            isLoading: isLoading,
                            onPressed: _onUpdateDataPressed,
                          ),
                          verticalSpace(20),
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