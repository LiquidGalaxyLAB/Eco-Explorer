sealed class ForestEvent{}

final class ForestFetched extends ForestEvent{}

class ForestSearchQueryChanged extends ForestEvent {
  final String query;
  ForestSearchQueryChanged(this.query);
}