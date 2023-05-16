import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CameraController {
  String? _imageUrl;
  XFile? _profilePicture;

  Future<XFile?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profilePicture = pickedFile;
      return _profilePicture;
    }
    return null;
  }

  Future<void> uploadImageToStorage(String userId) async {
    if (_profilePicture != null) {
      final file = File(_profilePicture!.path);
      Uint8List imageData = await file.readAsBytes();
      String fileName = 'profile_picture_$userId.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pictures').child(fileName);
      UploadTask uploadTask = storageReference.putData(imageData);
      TaskSnapshot taskSnapshot = await uploadTask;
      _imageUrl = await taskSnapshot.ref.getDownloadURL();
    }
  }

  set profilePicture(XFile? value) {
    _profilePicture = value;
  }

  XFile? get profilePicture => _profilePicture;

  String? get imageUrl => _imageUrl;
}
