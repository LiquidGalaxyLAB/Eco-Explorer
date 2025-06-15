import 'dart:async';

import 'package:eco_explorer/repositories/forest_repository.dart';
import 'package:eco_explorer/states/forest_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forests_model.dart';
import '../ref/api_provider.dart';

class ForestNotifier extends AsyncNotifier<ForestState> {
  late final ForestRepository repository;

  @override
  FutureOr<ForestState> build() {
    repository = ref.watch(forestRepositoryProvider);
    return ForestLoading();
  }

  Future<void> fetchForests() async {
    final data = await repository.getForests();
    state = AsyncData(ForestSuccess(allForests: data, visibleForests: data));
  }

  Future<void> searchForests(String query) async {
    final data = await repository.getForests();
    final filtered = data.forests.where((forest) {
      return forest.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = AsyncData(ForestSuccess(
      allForests: data,
      visibleForests: ForestsModel(forests: filtered),
    ));
  }

}