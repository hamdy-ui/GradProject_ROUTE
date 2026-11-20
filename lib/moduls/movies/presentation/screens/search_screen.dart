import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../manager/search_cubit.dart';
import '../manager/search_state.dart';
import '../widgets/movie_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<SearchCubit>().search(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              verticalSpace(16),
              // Search Text Field
              CustomTextField(
                controller: _searchController,
                hintText: 'Search',
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() {});
                  _onSearchChanged(val);
                },
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchCubit>().clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                validator: null,
              ),
              verticalSpace(16),
              // Results / Empty State
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    } else if (state is SearchErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppStyles.font16WhiteRegular,
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else if (state is SearchLoadedState) {
                      final movies = state.movies;
                      if (movies.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppAssets.empty,
                                width: 124,
                                height: 124,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.search_off_rounded,
                                  size: 100,
                                  color: AppColors.grey,
                                ),
                              ),
                              verticalSpace(16),
                              const Text(
                                'No movies found',
                                style: AppStyles.font16WhiteRegular,
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return MovieCardWidget(movie: movies[index]);
                        },
                      );
                    }

                    // Initial State (node-id=50-60): Empty Illustration
                    return Center(
                      child: Image.asset(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
