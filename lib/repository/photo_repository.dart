import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoRepository {
  Future<Map<String, dynamic>> uploadImage(String userId) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Crop image
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Gambar',
                toolbarColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                lockAspectRatio: true,
                aspectRatioPresets: [
                  CropAspectRatioPreset.ratio16x9,
                ]),
            IOSUiSettings(
              title: 'Crop Gambar',
            ),
          ],
        );

        if (croppedFile != null) {
          final file = File(croppedFile.path);
          final fileName = pickedFile.name; // Tetap gunakan nama file asli
          final filePath = '$userId/$fileName';
          debugPrint("file path: $filePath, file: $file");

          return {"file_path": filePath, "file": file};
        } else {
          throw Exception("Gambar tidak dicrop");
        }
      } else {
        throw Exception("Tidak ada gambar dipilih");
      }
    } catch (e) {
      rethrow;
    }
  }
}
