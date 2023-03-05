import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickVideo(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Video Selected');
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(
          context,
          'Try Again!',
        );
  }
  return video;
}

Future<File?> selectThumbNail(BuildContext context) async {
  File? video;
  String videoPath = video!.path;
  try {

    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
  
    // final pickedVideo =
    //     await ImagePicker().pickVideo(source: ImageSource.gallery);
        
    if (thumbnail != null) {
      video = File(thumbnail.path);
    }
  } catch (e) {
    showSnackBar(
          context,
          'Try Again!',
        );
  }
  return video;
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
