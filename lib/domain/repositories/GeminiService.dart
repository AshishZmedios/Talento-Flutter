import 'package:dio/dio.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class GeminiService {
  final Dio _dio = Dio();
  final String _apiKey = 'AIzaSyCxUPGNRv3KHbCW_D2AwwygrXyok3DUYNE';

  Future<String> generateResponse(String prompt) async {
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        },
      );

      final data = response.data;
      final candidates = data['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        return candidates[0]['content']['parts'][0]['text'];
      } else {
        return "No response from Gemini.";
      }
    } catch (e) {
      printInDebugMode("Gemini API error: $e");
      return "Error connecting to Gemini API.";
    }
  }
}
