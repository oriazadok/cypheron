import 'package:flutter/services.dart';
import 'dart:typed_data';

class FileHelper {
  // Define the MethodChannel with a unique name
  static const _channel = MethodChannel('com.example.cypheron/fileHelper');

  // This function will call the native Android code to read the file content
  static Future<Uint8List?> readContentUri(String uriPath) async {
    try {
      final result = await _channel.invokeMethod('readContentUri', {'uriPath': uriPath});
      return result;
    } on PlatformException catch (e) {
      print("Failed to read file from URI: '${e.message}'.");
      return null;
    }
  }
}
