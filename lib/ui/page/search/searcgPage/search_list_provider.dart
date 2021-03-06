import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_connect/bloc/search/index.dart';
import 'package:flutter_github_connect/bloc/search/search_event.dart';
import 'package:flutter_github_connect/helper/GIcons.dart';
import 'package:flutter_github_connect/ui/page/auth/repo/repo_list_screen.dart';
import 'package:flutter_github_connect/ui/page/common/no_data_page.dart';
import 'package:flutter_github_connect/ui/page/search/searcgPage/issue_list_page.dart';
import 'package:flutter_github_connect/ui/page/search/searcgPage/user_list_page.dart';

class SearchListProvider extends StatelessWidget {
  static MaterialPageRoute route({GithubSearchType type, String query}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<SearchBloc>(
        create: (BuildContext context) =>
            SearchBloc()..add(SearchForEvent(query: query, type: type)),
        child: SearchListProvider(
          query: query,
          type: type,
        ),
      ),
    );
  }

  final GithubSearchType type;
  final String query;
  const SearchListProvider({Key key, this.type, this.query}) : super(key: key);

  String _getAppBarTitle() {
    switch (type) {
      case GithubSearchType.People:
        return "People";
      case GithubSearchType.Repository:
        return "Repository";
      case GithubSearchType.Issue:
        return "Issues";

      default:
        return "People";
    }
  }

  void searchGithub(
    BuildContext context,
  ) {
    BlocProvider.of<SearchBloc>(context)
        .add(SearchForEvent(query: query, type: type));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(_getAppBarTitle()),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (
          BuildContext context,
          SearchState currentState,
        ) {
          if (currentState is ErrorRepoState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: () {},
                  ),
                ),
              ],
            ));
          }
          if (currentState is LoadedSearchState) {
            if (!(currentState.list != null && currentState.list.isNotEmpty)) {
              return Column(
                children: <Widget>[
                  NoDataPage(
                    title: "No ${_getAppBarTitle()} Found",
                    description: "Try again with different keyword",
                    icon: GIcons.github_1,
                  ),
                ],
              );
            }
            switch (currentState.type) {
              case GithubSearchType.Repository:
                return RepositoryListScreen(
                  isFromUserRepositoryListPage: true,
                  list: currentState.toRepositoryList(),
                  onScollToBottom: () => searchGithub(context),
                );
              case GithubSearchType.People:
                return UserListPage(
                  hideAppBar: true,
                  list: currentState.toUSerList(),
                );

              case GithubSearchType.Issue:
                return IssueListPage(
                  hideAppBar: true,
                  list: currentState.toIssueList(),
                );
              default:
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
