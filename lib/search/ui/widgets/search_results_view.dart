import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/widgets/search_item.dart';
import 'package:flutter_project/data/models/repositry_model.dart';
import 'package:flutter_project/injection_container.dart';
import 'package:flutter_project/search/cubit/search_cubit_cubit.dart';
import 'package:flutter_project/search/cubit/search_cubit_state.dart';

class SearchResultsView extends StatelessWidget {
  final SearchCubitState state;
  final Set<RepositoryModel> favoriteIds;
  final Function(RepositoryModel) onFavoriteToggle;

  const SearchResultsView({
    super.key,
    required this.state,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (state is SearchCubitLoading) {
      return _buildLoadingView();
    } else if (state is SearchCubitLoaded) {
      return _buildRepositoriesListView(
          (state as SearchCubitLoaded).repositories);
    } else if (state is SearchCubitError) {
      return _buildErrorView((state as SearchCubitError).message);
    } else if (state is HistoryCubitLoaded) {
      return _buildHistoryListView((state as HistoryCubitLoaded).repositories);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingView() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget _buildRepositoriesListView(List<RepositoryModel> repositories) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repo = repositories[index];
        return SearchItem(
          onTap: () => onFavoriteToggle(repo),
          title: repo.name,
          isInitiallyFavorite: favoriteIds.contains(repo),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: size8);
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Text('Error: $message'),
    );
  }

  Widget _buildHistoryListView(List<RepositoryModel> history) {
    if (history.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
              'You have empty history.\nClick on search to start journey!'),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final query = history[index];
        return SearchItem(
          onTap: () {
            sl<SearchCubit>().getRepositories(query.name);
            onFavoriteToggle(query);
          },
          title: query.name,
          isInitiallyFavorite: favoriteIds.contains(query),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: size8);
      },
    );
  }
}
