import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'model.dart';
import 'package:bloc/bloc.dart';

class LaunchesBloc extends Cubit<List<LaunchDataModel>> {
  LaunchesBloc() : super([]);

  String _searchQuery = '';
  Timer? _debounceTimer;
  bool _dataFetched = false;
  List<LaunchDataModel> _originalData = [];

  //search

  void startSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      updateSearchQuery(query);
    });
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    emit(filteredLaunches);
  }

  List<LaunchDataModel> get filteredLaunches {
    if (_searchQuery.isEmpty) {
      return _originalData; // Return the original unfiltered data when the search query is empty
    }

    return _originalData.where((launch) {
      final lowercaseName = launch.name.toLowerCase();
      final lowercaseLaunchDate = DateFormat('d MMM y')
          .format(DateTime.parse(launch.launchDate))
          .toLowerCase();
      return lowercaseName.contains(_searchQuery) ||
          lowercaseLaunchDate.contains(_searchQuery);
    }).toList();
  }

  //fetch data

  void fetchData() async {
    if (_dataFetched) {
      // If data is already fetched and the state is not empty, don't fetch again
      return;
    }
    try {
      final launches = await ApiService.get();

      final launchDataList = launches
          .map((launch) => LaunchDataModel(
                idMission: launch['id'] ?? 'No Data',
                name: launch['name'] ?? 'No Data',
                launchDate: launch['date_utc'] ?? 'No Data',
                img: List<String>.from(launch['links']['flickr']['original']),
                logo: launch['links']['patch']['large'].toString(),
                success: launch['success'].toString(),
                crew: List<dynamic>.from(launch['crew']),
                details: launch['details'] ?? 'No Data',
                landingAttempt:
                    launch['cores'][0]['landing_attempt'].toString(),
                landingSuccess:
                    launch['cores'][0]['landing_success'].toString(),
              ))
          .toList();
      _originalData = launchDataList;
      emit(launchDataList);
      _dataFetched = true;
    } catch (e) {
      // Handle error
    }
  }

  //Sort
  void sortByNameAZ() {
    _originalData
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(List<LaunchDataModel>.from(_originalData));
  }

  void sortByNameZA() {
    _originalData
        .sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    emit(List<LaunchDataModel>.from(_originalData));
  }

  void sortByDateOldestNewest() {
    _originalData.sort((a, b) =>
        DateTime.parse(a.launchDate).compareTo(DateTime.parse(b.launchDate)));
    emit(List<LaunchDataModel>.from(_originalData));
  }

  void sortByDateNewestOldest() {
    _originalData.sort((a, b) =>
        DateTime.parse(b.launchDate).compareTo(DateTime.parse(a.launchDate)));
    emit(List<LaunchDataModel>.from(_originalData));
  }
}
