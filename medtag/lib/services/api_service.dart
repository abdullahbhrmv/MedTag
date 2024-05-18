import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medtag/credentials.dart';

// İlaç bilgilerini fetch eden fonksiyon
Future<Map<String, dynamic>> fetchDrugInfo(String drugName) async {
  final response = await http.get(
    Uri.parse('https://api.fda.gov/drug/label.json?search=openfda.brand_name:$drugName&limit=10'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      return filterResults(data['results'], drugName);
    } else {
      throw Exception('No results found for the specified drug name');
    }
  } else {
    throw Exception('Failed to load drug info');
  }
}

// Dönen sonuçları filtreleme fonksiyonu
Map<String, dynamic> filterResults(List<dynamic> results, String drugName) {
  for (var result in results) {
    if (result['openfda'] != null &&
        result['openfda']['brand_name'] != null &&
        result['openfda']['brand_name'].contains(drugName.toUpperCase())) {
      return result;
    }
  }
  return results[0]; // Eğer tam eşleşme yoksa ilk sonucu döner
}

// Metni tercüme eden fonksiyon
Future<String> translateText(String text, String targetLanguage) async {
  final response = await http.post(
    Uri.parse('https://translation.googleapis.com/language/translate/v2'),
    body: {
      'q': text,
      'target': targetLanguage,
      'key': googleApiKey,
    },
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return body['data']['translations'][0]['translatedText'];
  } else {
    final body = json.decode(response.body);
    throw Exception('Failed to translate text: ${body['error']['message']}');
  }
}
