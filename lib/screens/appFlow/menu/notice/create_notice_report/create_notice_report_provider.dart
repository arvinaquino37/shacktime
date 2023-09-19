import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrm_app/custom_widgets/custom_dialog.dart';
import 'package:hrm_app/data/model/response_department_list.dart';
import 'package:hrm_app/data/server/respository/repository.dart';
import 'package:hrm_app/screens/appFlow/menu/notice/multi_select_department.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateNoticeReportProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  var subjectTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  String? noticeDate;
  File? attachmentPath;

  List<int> userIds = [];
  List<String> userNames = [];
  HashSet<Department> selectedItem = HashSet();



  /// get data from all team mate screen
  /// AppreciateTeammate screen
  void getAllUserData(BuildContext context) async {
    selectedItem.clear();
    userIds.clear();
    userNames.clear();
    selectedItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MultiSelectDepartment()),
    );
    for (var element in selectedItem) {
      userIds.add(element.id!);
      userNames.add(element.title!);
    }
    notifyListeners();
  }

  /// select date ......
  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      noticeDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      if (kDebugMode) {
        print(noticeDate);
      }
      notifyListeners();
    }
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

  Future createNoticeApi(context) async {
    var fileAttachment = attachmentPath?.path.split('/').last;
    final formDate = FormData.fromMap({
      "subject": subjectTextController.text,
      "date": noticeDate,
      "department_id": userIds.join(','),
      "description": descriptionTextController.text,
      "file": attachmentPath?.path != null
          ? await MultipartFile.fromFile(attachmentPath!.path,
          filename: fileAttachment)
          : null,
    });
    var apiResponse = await Repository.createNoteApi(formDate);
    if (apiResponse.result == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT, msg: apiResponse.message.toString());
    } else {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT, msg: apiResponse.message.toString());
    }
  }
}

