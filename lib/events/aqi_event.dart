sealed class AqiEvent{}

final class AqiFetched extends AqiEvent{
  final double lat;
  final double lon;

  AqiFetched({required this.lat, required this.lon});
}
