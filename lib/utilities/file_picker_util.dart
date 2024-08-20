import 'package:file_picker/file_picker.dart';

class FilePickerUtil {
  // Example method to pick a file
  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return result.files.single.path;
    } else {
      return null;
    }
  }
}
