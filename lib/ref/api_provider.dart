import 'package:dio/dio.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/models/historical_aqi/hist_aqi_model.dart';
import 'package:eco_explorer/notifiers/hist_aqi_notifier.dart';
import 'package:eco_explorer/providers/forest_data_provider.dart';
import 'package:eco_explorer/providers/nasa_firms_data_provider.dart';
import 'package:eco_explorer/repositories/fire_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../models/aqi/aqi_model.dart';
import '../notifiers/aqi_notifer.dart';
import '../notifiers/fire_notifier.dart';
import '../notifiers/forest_notifier.dart';
import '../providers/aqi_data_provider.dart';
import '../providers/local/db_provider.dart';
import '../providers/local/db_service.dart';
import '../repositories/aqi_repository.dart';
import '../repositories/forest_repository.dart';
import '../states/api_state.dart';
import '../states/forest_state.dart';

final dioProvider = Provider((ref) => Dio());

// Provider for API Service
final forestDataProvider = Provider<ForestDataProvider>((ref) => ForestDataProvider());
final aqiDataProvider = Provider<IAqiDataProvider>((ref) => AqiDataProvider());
final histAqiDataProvider = Provider<IAqiDataProvider>((ref) => HistAqiDataProvider());
final fireDataProvider = Provider<NasaFirmsDataProvider>((ref) => NasaFirmsDataProvider());

// Provider for local DB
final aqiDbProvider = Provider<DbProvider<AqiModel>>(
      (ref) => DbProvider<AqiModel>(dbService: DbService(key: Constants.aqiDb, adapter: AqiModelAdapter())),
);
final histAqiDbProvider = Provider<DbProvider<HistAqiModel>>(
      (ref) => DbProvider<HistAqiModel>(dbService: DbService(key: Constants.histAqiDb, adapter: HistAqiModelAdapter())),
);
final fireDbProvider = Provider<DbProvider<FireModel>>(
      (ref) => DbProvider<FireModel>(dbService: DbService(key: Constants.fireDb, adapter: FireModelAdapter())),
);

// Repository Provider
final forestRepositoryProvider = Provider<ForestRepository>((ref) {
  return ForestRepository(ref.watch(forestDataProvider));
});
final aqiRepositoryProvider = Provider<AqiRepository<AqiModel>>((ref) {
  return AqiRepository<AqiModel>(
    ref.watch(aqiDataProvider),
    ref.watch(aqiDbProvider),
        (map) => AqiModel.fromMap(map),
  );
});
final histAqiRepositoryProvider = Provider<AqiRepository<HistAqiModel>>((ref) {
  return AqiRepository<HistAqiModel>(
    ref.watch(histAqiDataProvider),
    ref.watch(histAqiDbProvider),
        (map) => HistAqiModel.fromMap(map),
  );
});
final fireRepositoryProvider = Provider<FireRepository>((ref) {
  return FireRepository(
    ref.watch(fireDataProvider),
    ref.watch(fireDbProvider)
  );
});

// Notifier Provider
final forestNotifierProvider = AsyncNotifierProvider<ForestNotifier, ForestState>(ForestNotifier.new);
final aqiNotifierProvider = AsyncNotifierProvider<AqiNotifier, ApiState>(AqiNotifier.new);
final histAqiNotifierProvider = AsyncNotifierProvider<HistAqiNotifier, ApiState>(HistAqiNotifier.new);
final fireNotifierProvider = AsyncNotifierProvider<FireNotifier, ApiState>(FireNotifier.new);

