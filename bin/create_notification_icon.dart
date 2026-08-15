import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputPath = 'assets/image/icon.png';
  final outputPath = 'android/app/src/main/res/drawable/notification_icon.png';
  
  final file = File(inputPath);
  if (!file.existsSync()) {
    print('Input file not found: $inputPath');
    return;
  }
  
  final bytes = file.readAsBytesSync();
  final image = img.decodeImage(bytes);
  if (image == null) {
    print('Failed to decode image');
    return;
  }

  // Convert to RGBA
  final rgbaImage = image.convert(numChannels: 4);

  // Iterate over pixels and make everything white, maintaining alpha
  for (var y = 0; y < rgbaImage.height; y++) {
    for (var x = 0; x < rgbaImage.width; x++) {
      final pixel = rgbaImage.getPixel(x, y);
      if (pixel.a > 0) {
        pixel.r = 255;
        pixel.g = 255;
        pixel.b = 255;
      }
    }
  }

  final outputBytes = img.encodePng(rgbaImage);
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsBytesSync(outputBytes);
  print('Created notification icon at $outputPath');
}
