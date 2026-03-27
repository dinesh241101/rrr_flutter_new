class AntiCheatService {
  final Map<String, DateTime> _lastSubmissions = <String, DateTime>{};

  bool isValidScore({required int score, required int maxScore}) {
    return score >= 0 && score <= maxScore;
  }

  bool canSubmit({required String playerId, required int cooldownSeconds}) {
    final DateTime? last = _lastSubmissions[playerId];
    if (last == null) {
      return true;
    }
    final Duration diff = DateTime.now().difference(last);
    return diff.inSeconds >= cooldownSeconds;
  }

  void recordSubmission(String playerId) {
    _lastSubmissions[playerId] = DateTime.now();
  }
}
