import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  ///Image Utils///
  //To pick image from device using image picker
  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    return selectedImage != null ? compressImage(selectedImage) : null;
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000); //returns random int from 1 to 10000
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    return File("$path/img_$rand.jpg")
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}
