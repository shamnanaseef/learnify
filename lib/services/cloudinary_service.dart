import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = 'debt2ctvw';
  final String uploadPreset = 'shamnaPre';

  Future<String?> uploadVideo(File file) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/video/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('video', 'mp4'),
      ));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(resBody);
      return data['secure_url'];
    } else {
      print('Upload failed: $resBody');
      return null;
    }
  }
}