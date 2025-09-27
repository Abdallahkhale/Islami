class ReciterResponse {
  final List<Reciter> reciters;

  ReciterResponse({required this.reciters});

  factory ReciterResponse.fromJson(Map<String, dynamic> json) {
    return ReciterResponse(
      reciters: (json['reciters'] as List)
          .map((reciter) => Reciter.fromJson(reciter))
          .toList(),
    );
  }
}

class Reciter {
  final int id;
  final String name;
  final String letter;
  final String date;
  final List<Moshaf> moshaf;

  Reciter({
    required this.id,
    required this.name,
    required this.letter,
    required this.date,
    required this.moshaf,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'],
      name: json['name'],
      letter: json['letter'],
      date: json['date'],
      moshaf: (json['moshaf'] as List)
          .map((moshaf) => Moshaf.fromJson(moshaf))
          .toList(),
    );
  }
}

class Moshaf {
  final int id;
  final String name;
  final String server;
  final int surahTotal;
  final int moshafType;
  final String surahList;

  Moshaf({
    required this.id,
    required this.name,
    required this.server,
    required this.surahTotal,
    required this.moshafType,
    required this.surahList,
  });

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      surahTotal: json['surah_total'],
      moshafType: json['moshaf_type'],
      surahList: json['surah_list'],
    );
  }

  List<String> getSurahUrls() {
    List<String> urls = [];
    List<String> surahNumbers = surahList.split(',');
    
    for (String surahNumber in surahNumbers) {
      String paddedNumber = surahNumber.padLeft(3, '0');
      urls.add('$server$paddedNumber.mp3');
    }
    
    return urls;
  }
}
