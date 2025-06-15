import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/aqi/aqi_model.dart';
import '../../repositories/aqi_repository.dart';
import '../../states/api_state.dart';
import '../ref/api_provider.dart';

class AqiNotifier extends AsyncNotifier<ApiState> {
  late final AqiRepository<AqiModel> repository;

  @override
  FutureOr<ApiState> build() {
    repository = ref.watch(aqiRepositoryProvider);
    return ApiInitial();
  }

  Future<void> fetchAqi(WidgetRef ref, double lat, double lon) async {
    state = AsyncData(ApiLoading());
    try {
      final data = await repository.getPollutionData(ref, lat, lon);
      print('Fetched AQI: $data');
      state = AsyncData(ApiSuccess<AqiModel>(model: data));
    } catch (e) {
      state = AsyncData(ApiFailure(error: e.toString()));
    }
  }
}