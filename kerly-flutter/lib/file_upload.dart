import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;


class FileUpload {

  static Future<void> uploadFile(int id, String username, String itemType, String itemName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final filePath = result.files.single.path;

      var dio = Dio();

      var formData = FormData();
      formData.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(filePath!),
        ),
      );

      formData
        ..fields.addAll([
          MapEntry("uploaderId", username), // Null check operator used with null value
          MapEntry("bid", id.toString()),
          MapEntry("itemType", itemType),
          MapEntry("itemName", itemName),
        ]);

      final response = await dio.post(
        "http://10.0.2.2:9007/file-service/fileUpload",
        data: formData,
      );
      print(response.statusCode);
    }
  }

  static Future<void> deleteFile(int id) async {

    String url = 'http://10.0.2.2:9007/file-service/fileDelete';

    Map<String, dynamic> body = {"bid": id};

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
    } finally {}
  }

}
