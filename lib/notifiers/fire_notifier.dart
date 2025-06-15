import 'dart:async';

import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/repositories/fire_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ref/api_provider.dart';
import '../states/api_state.dart';

class FireNotifier extends AsyncNotifier<ApiState> {
  late final FireRepository repository;

  @override
  FutureOr<ApiState> build() {
    repository = ref.watch(fireRepositoryProvider);
    return ApiInitial();
  }

  Future<void> fetchActiveFires(WidgetRef ref, String forest, int range) async {
    state = AsyncData(ApiLoading());
    try {
      FireModel data = FireModel(fires: []);
      for (String country in forestToCountry[forest]!) {
        print('Fetching fire data for $country...');
        final model = await repository.getFireData(ref, country, range);
        data.fires.addAll(model.fires);
      }
      state = AsyncData(ApiSuccess<FireModel>(model: data));
    } catch (e) {
      state = AsyncData(ApiFailure(error: e.toString()));
    }
  }
}

Map<String, List<String>> forestToCountry = {
  'Amazon Rainforest': ['BRA', 'PER', 'COL', 'VEN', 'ECU', 'BOL', 'GUY', 'SUR', 'GUF'],
  'Congolian Rainforest': ['COD', 'COG', 'CAF', 'CMR', 'GAB', 'GNQ'],
  'New Guinea Rainforest': ['IDN', 'PNG'],
  'East Siberian Taiga': ['RUS'],
  'The Sundarbans': ['BGD', 'IND'],
  'Appalachian Rainforest': ['USA'],
  'Valdivian Temperate Forest': ['CHL', 'ARG'],
  'Daintree Rainforest': ['AUS'],
};