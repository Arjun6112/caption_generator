import 'package:caption_generator/secrets/app_secrets.dart';
import 'package:dio/dio.dart';

class CaptionRepo {
  Dio dio = Dio();

  Future<List<String>> getCaptions() async {
    try {
      Response response = await dio.post(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro-vision:generateContent?key=${AppSecrets.API_KEY}',
          data: {
  "contents": [
    {
      "parts": [
        {
          "inlineData": {
            "mimeType": "image/jpeg",
            "data": ""
          }
        },
        {
          "text": "Generate 5 Instagram captions for this picture. Keep it really short and witty."
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.4,
    "topK": 32,
    "topP": 1,
    "maxOutputTokens": 4096,
    "stopSequences": []
  },
  "safetySettings": [
    {
      "category": "HARM_CATEGORY_HARASSMENT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_HATE_SPEECH",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    }
  ]
});
      List<String> captions = [];
      response.data.forEach((caption) {
        captions.add(caption['name']);
      });
      return captions;
    } catch (e) {
      print(e);
    }

    return [];
  }
}
