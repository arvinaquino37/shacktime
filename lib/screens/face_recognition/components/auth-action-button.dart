import 'package:flutter/material.dart';
import 'package:hrm_app/data/server/respository/face_recognition_repository/face_recognition_repository.dart';
import 'package:hrm_app/screens/face_recognition/components/app_button.dart';
import 'package:hrm_app/screens/face_recognition/face_registration_sucess.dart';
import 'package:hrm_app/services/camera.service.dart';
import 'package:hrm_app/services/locator/locator.dart';
import 'package:hrm_app/services/ml_service.dart';
import 'package:hrm_app/utils/nav_utail.dart';

List kUserFaceData = [];

class AuthActionButton extends StatefulWidget {
  const AuthActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload}) : super(key: key);

  final Function onPressed;
  final bool isLogin;
  final Function reload;

  @override
  AuthActionButtonState createState() => AuthActionButtonState();
}

class AuthActionButtonState extends State<AuthActionButton> {

  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  ///sign up page =====================
  Future _registerFace(context) async {
    List predictedData = _mlService.predictedData;

    _mlService.setPredictedData([]);
    bool predictSuccess = await postFaceRegistration(predictedData);
    if (predictSuccess) {

      NavUtil.replaceScreen(context, FaceRegistrationSuccess(faceImagePath: _cameraService.imagePath,));
    }
  }

  /// register face
  Future<bool> postFaceRegistration(pData) async {
    // kUserFaceData = pData;
    final data = {
      'face_data': pData,
    };
    final response = await FaceRecognitionRepository.registerFace(data);
    if (response['result'] == true) return true;

    return false;
  }

  Future<bool?> _predictUser() async {
    bool? isMatched = await _mlService.predict();
    return isMatched;
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        if (widget.isLogin) {
          bool? isMatched = await _predictUser();
          if (isMatched == true) {}

          print('user found');
        }
        PersistentBottomSheetController bottomSheetController =
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin
              ? const Text(
                  'Face Matched ',
                  style: TextStyle(fontSize: 20),
                )
              : widget.isLogin
                  ? const Text(
                      'User not found 😞',
                      style: TextStyle(fontSize: 20),
                    )
                  : Container(),
          Column(
            children: [
              const SizedBox(height: 10),
              AppButton(
                text: 'Register Face',
                onPressed: () async {
                  await _registerFace(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
