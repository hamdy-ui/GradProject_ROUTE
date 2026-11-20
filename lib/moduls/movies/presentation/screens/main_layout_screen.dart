import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/manager/profile_cubit.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../manager/browse_cubit.dart';
import '../manager/movies_cubit.dart';
import '../manager/search_cubit.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'browse_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;

  const MainLayoutScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MoviesCubit.create()),
        BlocProvider(create: (_) => SearchCubit.create()),
        BlocProvider(create: (_) => BrowseCubit.create()),
        BlocProvider(create: (_) => ProfileCubit.create()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                HomeScreen(onNavigateTab: _onTabChanged),
                const SearchScreen(),
                const BrowseScreen(),
                const ProfileScreen(),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onTabChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
