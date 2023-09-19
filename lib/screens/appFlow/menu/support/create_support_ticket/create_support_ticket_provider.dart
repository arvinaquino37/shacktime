import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrm_app/custom_widgets/custom_dialog.dart';
import 'package:hrm_app/data/server/respository/repository.dart';
import 'package:hrm_app/screens/appFlow/menu/support/support_ticket/support_screen.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:image_picker/image_picker.dart';

class CreateSupportTicketProvider extends ChangeNotifier {
  String? selectedPriority;
  int? selectedType;
  var subjectTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  File? attachmentPath;
  String? errorSubject;
  String? errorDescription;
  String? errorMessage;
  String? writeSubject = "";
  String? writeDescription = "";

  /// select gender
  void genderSelectedValue(String val) {
    selectedPriority = val;
    notifyListeners();
  }

  ///Pick Attachment from Camera and Gallery
  Future<dynamic> pickAttachmentImage(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogImagePicker(
          onCameraClick: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                maxHeight: 300,
                maxWidth: 300,
                imageQuality: 90);
            attachmentPath = File(image!.path);
            notifyListeners();
            if (kDebugMode) {
              print(File(image.path));
            }
          },
          onGalleryClick: () async {
            final ImagePicker pickerGallery = ImagePicker();
            final XFile? imageGallery = await pickerGallery.pickImage(
                source: ImageSource.gallery,
                maxHeight: 300,
                maxWidth: 300,
                imageQuality: 90);
            attachmentPath = File(imageGallery!.path);
            notifyListeners();
            if (kDebugMode) {
              print(File(imageGallery.path));
            }
            notifyListeners();
          },
        );
      },
    );
    notifyListeners();
  }

  /// select Priority type
  /// priority_id => [14 = high , 15 = medium , 16 = low' ]
  void genderType(genderValue) {
    if (genderValue == 'High') {
      selectedType = 14;
    } else if (genderValue == 'Medium') {
      selectedType = 15;
    } else if (genderValue == 'Low') {
      selectedType = 16;
    }
  }

  /// support create API
  void supportCreateApi(context) async {
    var apiResponse = await Repository.supportCreateApi(
        subjectTextController.text,
        descriptionTextController.text,
        attachmentPath,
        selectedType ?? 14);
    if (apiResponse.result == true) {
      Fluttertoast.showToast(
          msg: apiResponse.data?.message ?? "",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      notifyListeners();
      NavUtil.replaceScreen(context, const SupportScreen());
    } else {
      errorSubject = apiResponse.error?.laravelValidationError?.subject;
      errorDescription = apiResponse.error?.laravelValidationError?.description;
      errorMessage = apiResponse.message;
      notifyListeners();
      Fluttertoast.showToast(
          msg: apiResponse.message ?? "",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }
}
