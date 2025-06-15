import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forests_model.dart';

//Map control
StateProvider<double?> latitudeProvider = StateProvider<double?>((ref) => null);
StateProvider<double?> longitudeProvider = StateProvider<double?>((ref) => null);
StateProvider<double?> altitudeProvider = StateProvider<double?>((ref) => null);
StateProvider<double?> zoomProvider = StateProvider<double?>((ref) => null);
StateProvider<double?> tiltProvider = StateProvider<double?>((ref) => null);
StateProvider<double?> headingProvider = StateProvider<double?>((ref) => null);

void setMap(WidgetRef ref,double lat, double lon, double alt, double zoom, double tilt, double heading){
  ref.read(latitudeProvider.notifier).state = lat;
  ref.read(longitudeProvider.notifier).state = lon;
  ref.read(altitudeProvider.notifier).state = alt;
  ref.read(zoomProvider.notifier).state = zoom;
  ref.read(tiltProvider.notifier).state = tilt;
  ref.read(headingProvider.notifier).state = heading;
}

//app control
void onChangedTab(WidgetRef ref, StateProvider<int> index, int newIndex) {
  ref.read(index.notifier).state = newIndex;
}

StateProvider<List<Forest>> forestListProvider = StateProvider<List<Forest>>((ref) => []);
StateProvider<int> homeIndexProvider = StateProvider<int>((ref) => 0);
StateProvider<int> dashboardIndexProvider = StateProvider<int>((ref) => 0);
StateProvider<int> mapIndexProvider = StateProvider<int>((ref) => 0);

final List<String> labels = ['Satellite', 'Terrain', 'Hybrid'];



