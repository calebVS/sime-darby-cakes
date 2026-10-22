import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dgyqbv0f5';
  static const String uploadPreset = 'citytalk_preset'; // Replace with your exact Unsigned Preset

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(responseData);
        return jsonMap['secure_url'] as String;
      } else {
        print('Cloudinary upload error (${response.statusCode}): $responseData');
        return null;
      }
    } catch (e) {
      print('Exception during Cloudinary upload: $e');
      return null;
    }
  }
}