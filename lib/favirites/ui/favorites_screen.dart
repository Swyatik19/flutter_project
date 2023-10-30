import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/icons/icons.dart';
import 'package:flutter_project/core/textStyle/textStyle.dart';
import 'package:flutter_project/core/widgets/custom_app_bar.dart';
import 'package:flutter_project/core/widgets/search_item.dart';
import 'package:flutter_project/data/models/repositry_model.dart';
import 'package:flutter_project/favirites/cubit/favorites_cubit_cubit.dart';
import 'package:flutter_project/favirites/cubit/favorites_cubit_state.dart';
import 'package:flutter_project/injection_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            isIconRight: false,
            iconFavoritesBottom: iconStars,
            iconBackBottom: iconLeft,
            favoriteBottomCallback: () {},
            backCallback: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: size24,
          ),
          BlocBuilder<FavoritesCubit, FavoritesState>(
            bloc: sl(),
            builder: (context, state) {
              return _buildStateView(state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStateView(FavoritesState state) {
    if (state is FavoritesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is FavoritesLoaded) {
      return _buildFavoritesListView(state.favorites);
    } else if (state is FavoritesError) {
      return _buildErrorView();
    }
    return const SizedBox.shrink();
  }

  Widget _buildFavoritesListView(List<RepositoryModel> favorites) {
    if (favorites.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'You have no favorites.\nClick on star while searching to add first favorite',
            textAlign: TextAlign.center,
            style: helperText,
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          RepositoryModel repo = favorites[index];
          return SearchItem(
            onTap: () => sl<FavoritesCubit>().removeFavorite(repo.id),
            title: repo.name,
            isInitiallyFavorite: true,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: size8);
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Expanded(
      child: Center(child: SvgPicture.asset(iconBan)),
    );
  }
}
