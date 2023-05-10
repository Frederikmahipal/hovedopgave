import 'package:image_picker/image_picker.dart';

class CameraController {
  XFile? _profilePicture;

  Future<XFile?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profilePicture = pickedFile;
      return _profilePicture;
    }
    return null;
  }

  set profilePicture(XFile? value) {
    _profilePicture = value;
  }

  XFile? get profilePicture => _profilePicture;

  
}