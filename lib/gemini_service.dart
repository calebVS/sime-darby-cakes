import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Paste your Gemini API key from AI Studio here:
  static const String _geminiApiKey = 'AQ.Ab8RN6JU_ZkwofByisaO-2fmiwoaNC6f7O_xpIEBrKxD46zc1Q';

  static Future<String> detectIssue(File imageFile) async {
    try {
      // 1. Initialize Gemini Flash model
      final model = GenerativeModel(
        model: 'gemini-3.8-flash',
        apiKey: _geminiApiKey,
      );

      // 2. Read image bytes
      final imageBytes = await imageFile.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      // 3. Prompt Gemini to classify into one of your 3 app categories
     const prompt = 
        'Analyze this civic image and respond with ONLY ONE WORD from these three choices: '
        '"Roads" (for potholes, cracked asphalt, road issues), '
        '"Lighting" (for streetlights, dark lamps, electrical poles), or '
        '"Waste" (for trash, garbage, litter). '
        'Do not reply with any extra text or punctuation.';

      // 4. Send request
      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);
     

      final textResult = response.text?.trim() ?? 'Roads';
      print('✨ Gemini Detection Result: $textResult');

      // 5. Match result to app category chips
      if (textResult.contains('Lighting')) return 'Lighting';
      if (textResult.contains('Waste')) return 'Waste';
      return 'Roads';
    } catch (e) {
      print('Gemini API Error: $e');
      return 'Roads'; // Fallback
    }
  }
}