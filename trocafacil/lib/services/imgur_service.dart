import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImgurService {
  static const String _clientId = '470a096d41fd57e';
  static const String _apiUrl = 'https://api.imgur.com/3/image';
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Client-ID $_clientId',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'image': base64Image, 'type': 'base64'}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return responseData['data']['link'];
        }
      }
      print('Imgur upload failed: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Error uploading to Imgur: $e');
      return null;
    }
  }
}
