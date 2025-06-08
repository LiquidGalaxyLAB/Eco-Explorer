sealed class FireEvent{}

final class FirmsApiFetched extends FireEvent{
  final String forest;
  final int range;

  FirmsApiFetched({required this.forest, required this.range});
}