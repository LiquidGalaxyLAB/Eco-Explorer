import 'dart:async';

import 'package:eco_explorer/models/historical_aqi/hist_aqi_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ref/api_provider.dart';
import '../repositories/aqi_repository.dart';
import '../states/api_state.dart';

class HistAqiNotifier extends AsyncNotifier<ApiState> {
  late final AqiRepository<HistAqiModel> repository;

  @override
  FutureOr<ApiState> build() {
    repository = ref.watch(histAqiRepositoryProvider);
    return ApiInitial();
  }

  Future<void> fetchHistAqi(WidgetRef ref, double lat, double lon) async {
    state = AsyncData(ApiLoading());

    try {
      final data = await repository.getPollutionData(ref, lat, lon);
      state = AsyncData(ApiSuccess<HistAqiModel>(model: data));
    } catch (e) {
      state = AsyncData(ApiFailure(error: e.toString()));
    }
  }
}