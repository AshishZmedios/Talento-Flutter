import 'package:dio/dio.dart';

class GeminiService {
    final Dio _dio = Dio();
    final String _apiKey = "AIzaSyBPy2uGFpi64TABF89hv4mzRDiADmgmLUk";

    Future<String> generateResponse(String prompt) async {
        final String url = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$_apiKey';

        try {
            final response =await _dio.post(url, options:Options(headers:{
                'Content-Type':'application/json',
            }),
            data:
            {
                "contents": [
                {
                    "parts": [
                    {
                        "text":prompt
                    }
              ]
                }
          ]
            },
      );

            final data =response.data;
            final candidates =data['candidates'];
            if (candidates != null && candidates.isNotEmpty) {
                return candidates[0]['content']['parts'][0]['text'];
            } else {
                return "No response from Gemini.";
            }
        } catch (e) {
            print("Gemini error: $e");
            return "Error getting response from Gemini.";
        }
    }
}
