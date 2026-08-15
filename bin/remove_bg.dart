import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  processImage('assets/image/logo2.png');
  processImage('assets/image/icon.png');
}

void processImage(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    print('File not found: $path');
    return;
  }
  final bytes = file.readAsBytesSync();
  final image = img.decodeImage(bytes);
  if (image == null) {
    print('Failed to decode image: $path');
    return;
  }

  // Convert to RGBA
  final rgbaImage = image.convert(numChannels: 4);

  // Iterate over pixels and make white transparent
  // We'll use a tolerance to catch near-white pixels as well
  for (var y = 0; y < rgbaImage.height; y++) {
    for (var x = 0; x < rgbaImage.width; x++) {
      final pixel = rgbaImage.getPixel(x, y);
      if (pixel.r > 245 && pixel.g > 245 && pixel.b > 245) {
        pixel.a = 0;
      }
    }
  }

  final outputBytes = img.encodePng(rgbaImage);
  file.writeAsBytesSync(outputBytes);
  print('Processed $path successfully');
}
