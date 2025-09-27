class RadioResponse {
  final List<RadioStation> radios;

  RadioResponse({required this.radios});

  factory RadioResponse.fromJson(Map<String, dynamic> json) {
    return RadioResponse(
      radios: (json['radios'] as List)
          .map((radio) => RadioStation.fromJson(radio))
          .toList(),
    );
  }
}

class RadioStation {
  final int id;
  final String name;
  final String url;
  final String recentDate;

  RadioStation({
    required this.id,
    required this.name,
    required this.url,
    required this.recentDate,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      recentDate: json['recent_date'],
    );
  }
}
