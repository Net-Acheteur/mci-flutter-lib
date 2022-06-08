import 'package:cross_file/cross_file.dart';

class ImageHelper {
  static bool isFileAPicture(String filename) {
    if (filename.endsWith(".png") ||
        filename.endsWith(".jpg") ||
        filename.endsWith(".jpeg") ||
        filename.endsWith(".gif")) {
      return true;
    }
    return false;
  }

  static Future<int> fileSizeInMegaBytes(XFile file) async {
    int sizeInBytes = await file.length();
    return (sizeInBytes / 1048576).round();
  }
}
