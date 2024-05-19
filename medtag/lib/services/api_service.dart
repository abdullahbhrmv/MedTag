import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medtag/credentials.dart';


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
