/// PopResult
class PopWithResults {
  /// poped from this page
  final String fromPage;

  /// pop until this page
  final String toPage;

  /// results
  final List<String>? results;

  /// constructor
  PopWithResults(
      {required this.fromPage, required this.toPage, this.results});
}