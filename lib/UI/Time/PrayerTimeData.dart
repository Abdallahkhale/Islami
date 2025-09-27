class PrayerTime {
  final String name;
  final String time;
  final String period;
  final bool isActive;

  PrayerTime({
    required this.name,
    required this.time,
    required this.period,
    this.isActive = false,
  });
}