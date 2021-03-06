import 'package:flutter_github_connect/bloc/User/User_model.dart';
import 'package:flutter_github_connect/bloc/User/model/event_model.dart';
import 'package:flutter_github_connect/bloc/User/model/gist_model.dart';
import 'package:flutter_github_connect/bloc/issues/index.dart';
import 'package:flutter_github_connect/bloc/notification/index.dart';
import 'package:flutter_github_connect/bloc/search/index.dart';
import 'package:flutter_github_connect/model/pul_request.dart';
import 'package:flutter_github_connect/bloc/people/people_model.dart' as people;
import 'package:flutter_github_connect/bloc/search/model/search_userModel.dart'
    as model;
import 'package:flutter_github_connect/bloc/bloc/repo_response_model.dart';
abstract class ApiGateway{
   Future<UserModel> fetchUserProfile({String login});
   Future<UserModel>fetchNextRepositorries({String login, String endCursor});
   Future<List<EventModel>> fetchUserEvent();
   Future<List<RepositoryModel2>> fetchRepositories();
   Future<List<NotificationModel>>  fetchNotificationList();
   Future<model.Search> searchQuery({GithubSearchType type, String query,String endCursor});
   Future<List<IssuesModel>> fetchIssues({String login});
   Future<UserPullRequests> fetchPullRequest({String login});
   Future<Gists> fetchGistList({String login});
   Future<people.Followers> fetchFollowersList(String login);
   Future<people.Following> fetchFollowingList(String login);
   Future<RepositoryModel> fetchRepository({String name, String owner});
   Future<String> fetchReadme({String name, String owner});
}