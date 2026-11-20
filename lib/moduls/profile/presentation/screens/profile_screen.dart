import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../movies/presentation/widgets/movie_card_widget.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ProfileCubit>().loadProfileData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null && modalRoute.isCurrent && context.mounted) {
      context.read<ProfileCubit>().loadProfileData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && context.mounted) {
      context.read<ProfileCubit>().loadProfileData();
    }
  }

  void _onExitPressed(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Exit', style: AppStyles.font20PrimaryBold),
        content: const Text(
          'Are you sure you want to log out?',
          style: AppStyles.font14WhiteRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileAccountDeletedState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is ProfileErrorState) {
            return Center(
              child: Text(
                state.message,
                style: AppStyles.font16WhiteRegular,
              ),
            );
          } else if (state is ProfileLoadedState) {
            final user = state.user;
            final wishlist = state.wishlist;
            final history = state.history;
            final selectedTab = state.selectedTab;

            // Pick avatar asset based on index
            final avatarAsset = (user != null &&
                user.avatarIndex >= 0 &&
                user.avatarIndex < AppAssets.allAvatars.length)
                ? AppAssets.allAvatars[user.avatarIndex]
                : AppAssets.avatar1;

            final currentList =
            selectedTab == ProfileTab.wishlist ? wishlist : history;

            return CustomScrollView(
              slivers: [
                // Profile Header Container (node-id=51-570)
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.containerDark,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top info: Avatar & Name on left, Counters on right
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar & Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      avatarAsset,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  verticalSpace(10),
                                  Text(
                                    user?.name ?? 'User Name',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Counters: Wishlist & History
                              Row(
                                children: [
                                  _buildCounter(
                                    count: '${wishlist.length}',
                                    label: 'Wish List',
                                  ),
                                  const SizedBox(width: 24),
                                  _buildCounter(
                                    count: '${history.length}',
                                    label: 'History',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          verticalSpace(24),
                          // Action Buttons: Edit Profile & Exit
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        AppRoutes.updateProfile,
                                      );
                                      if (context.mounted) {
                                        context
                                            .read<ProfileCubit>()
                                            .loadProfileData();
                                      }
                                    },
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.redButton,
                                      foregroundColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () => _onExitPressed(context),
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Exit',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.exit_to_app_rounded,
                                          size: 20,
                                          color: AppColors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(28),
                          // Tabs: Watch List & History
                          Row(
                            children: [
                              Expanded(
                                child: _buildTab(
                                  context: context,
                                  title: 'Watch List',
                                  icon: Icons.bookmark_rounded,
                                  isSelected:
                                  selectedTab == ProfileTab.wishlist,
                                  onTap: () => context
                                      .read<ProfileCubit>()
                                      .switchTab(ProfileTab.wishlist),
                                ),
                              ),
                              Expanded(
                                child: _buildTab(
                                  context: context,
                                  title: 'History',
                                  icon: Icons.folder_rounded,
                                  isSelected: selectedTab == ProfileTab.history,
                                  onTap: () => context
                                      .read<ProfileCubit>()
                                      .switchTab(ProfileTab.history),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content Sliver
                currentList.isEmpty
                    ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.empty,
                          width: 124,
                          height: 124,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.movie_filter_outlined,
                            size: 100,
                            color: AppColors.grey,
                          ),
                        ),
                        verticalSpace(16),
                        Text(
                          selectedTab == ProfileTab.wishlist
                              ? 'No movies in Wish List'
                              : 'No watch history yet',
                          style: AppStyles.font16WhiteRegular,
                        ),
                      ],
                    ),
                  ),
                )
                    : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
                  sliver: SliverGrid(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final movie = currentList[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.movieDetails,
                              arguments: movie,
                            );
                            if (context.mounted) {
                              context
                                  .read<ProfileCubit>()
                                  .loadProfileData();
                            }
                          },
                          child: AbsorbPointer(
                            child: MovieCardWidget(
                              movie: movie,
                              borderRadius: 16,
                            ),
                          ),
                        );
                      },
                      childCount: currentList.length,
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCounter({required String count, required String label}) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        verticalSpace(4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.white,
                size: 26,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.white,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Container(
            height: 3,
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}