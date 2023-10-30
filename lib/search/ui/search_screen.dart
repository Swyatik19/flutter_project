import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/icons/icons.dart';
import 'package:flutter_project/core/textStyle/textStyle.dart';
import 'package:flutter_project/core/widgets/custom_app_bar.dart';
import 'package:flutter_project/core/widgets/search_input.dart';
import 'package:flutter_project/data/models/repositry_model.dart';
import 'package:flutter_project/favirites/cubit/favorites_cubit_cubit.dart';
import 'package:flutter_project/favirites/cubit/favorites_cubit_state.dart';
import 'package:flutter_project/favirites/ui/favorites_screen.dart';

import 'package:flutter_project/injection_container.dart';
import 'package:flutter_project/search/cubit/search_cubit_cubit.dart';
import 'package:flutter_project/search/cubit/search_cubit_state.dart';
import 'package:flutter_project/search/ui/widgets/search_results_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    sl<SearchCubit>().loadSearchHistory();
    sl<FavoritesCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          const SizedBox(height: size24),
          _buildSearchInput(),
          const SizedBox(height: size16),
          _buildTitle(),
          const SizedBox(height: size20),
          _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      isIconRight: true,
      iconFavoritesBottom: iconStars,
      iconBackBottom: iconLeft,
      favoriteBottomCallback: () {
        sl<FavoritesCubit>().getFavorites();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
      },
      backCallback: () {},
    );
  }

  Widget _buildSearchInput() {
    return SearchInput(
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          sl<SearchCubit>().getRepositories(value);
        }
      },
      onChanged: (value) {
        if (value.isEmpty) {
          sl<SearchCubit>().loadSearchHistory();
        }
      },
    );
  }

  Widget _buildTitle() {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      bloc: sl(),
      builder: (context, searchState) {
        String title;
        if (searchState is SearchCubitLoading ||
            searchState is SearchCubitInitial) {
          title = 'What we found';
        } else if (searchState is SearchCubitLoaded) {
          title = 'What we have found';
        } else {
          title = 'Search History';
        }
        return Padding(
          padding: const EdgeInsets.only(left: size16),
          child: Text(title, style: typeListText),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: BlocConsumer<FavoritesCubit, FavoritesState>(
        bloc: sl(),
        listener: (context, favoritesState) {
          if (favoritesState is FavoritesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(favoritesState.message)),
            );
          }
        },
        builder: (context, favoritesState) {
          return BlocBuilder<SearchCubit, SearchCubitState>(
            bloc: sl(),
            builder: (context, searchState) {
              return SearchResultsView(
                state: searchState,
                favoriteIds: (favoritesState is FavoritesLoaded)
                    ? Set<RepositoryModel>.from(favoritesState.favorites)
                    : <RepositoryModel>{},
                onFavoriteToggle: (repo) {
                  if (favoritesState is FavoritesLoaded &&
                      favoritesState.favorites.contains(repo)) {
                    sl<FavoritesCubit>()
                        .removeFavorite(repo.id)
                        .then((value) => sl<FavoritesCubit>().getFavorites());
                  } else {
                    sl<FavoritesCubit>()
                        .addFavorite(repo)
                        .then((value) => sl<FavoritesCubit>().getFavorites());
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
