// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:image_picker/image_picker.dart';

pickImge(ImageSource source) async{
  final ImagePicker imagePicker = ImagePicker();

  XFile? picture =  await imagePicker.pickImage(source: source);
  if(picture != null){
    return await picture.readAsBytes();
  }

  print("No image selected");
} 