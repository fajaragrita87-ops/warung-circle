import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class FilePickerHelper {
  static Future<Uint8List?> pickImage() async {
    final completer = Completer<Uint8List?>();
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          completer.complete(reader.result as Uint8List?);
        });
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}
