class LeaderboardData {
  final String name;
  final int correctCroatian;
  final int correctEnglish;
  final double timeCroatian;
  final double timeEnglish;

  LeaderboardData({
    required this.name,
    required this.correctCroatian,
    required this.correctEnglish,
    required this.timeCroatian,
    required this.timeEnglish,
  });

  factory LeaderboardData.fromMap(Map<String, dynamic> map) {
    return LeaderboardData(
      name: map['name'],
      correctCroatian: map['correctCroatian'] ?? 0,
      correctEnglish: map['correctEnglish'] ?? 0,
      timeCroatian: (map['timeCroatian'] ?? 0).toDouble(),
      timeEnglish: (map['timeEnglish'] ?? 0).toDouble(),
    );
  }
}
