sealed class HistAqiEvent{}

final class HistAqiFetched extends HistAqiEvent{
  final double lat;
  final double lon;

  HistAqiFetched({required this.lat, required this.lon});
}