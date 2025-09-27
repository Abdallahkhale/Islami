import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:islami/UI/Radio/Model/radio_model.dart';
import 'package:islami/UI/Radio/Model/reciter_model.dart';

class ApiService {
  static const String baseUrl = 'https://mp3quran.net/api/v3';

  static Future<RadioResponse> getRadios() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/radios?language=ar'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return RadioResponse.fromJson(decodedResponse);
      } else {
        throw Exception('Failed to load radios');
      }
    } catch (e) {
      throw Exception('Error fetching radios: $e');
    }
  }

  static Future<ReciterResponse> getReciters() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reciters?language=ar'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return ReciterResponse.fromJson(decodedResponse);
      } else {
        throw Exception('Failed to load reciters');
      }
    } catch (e) {
      throw Exception('Error fetching reciters: $e');
    }
  }
}

class SurahItem {
  final String reciterName;
  final int surahNumber;
  final String audioUrl;

  SurahItem({
    required this.reciterName,
    required this.surahNumber,
    required this.audioUrl,
  });
}