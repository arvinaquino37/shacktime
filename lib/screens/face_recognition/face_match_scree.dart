import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance.dart';
import 'package:hrm_app/screens/face_recognition/components/app_button.dart';
import 'package:hrm_app/screens/face_recognition/components/auth_button.dart';
import 'package:hrm_app/screens/face_recognition/components/camera_detection_preview.dart';
import 'package:hrm_app/screens/face_recognition/components/single_picture.dart';
import 'package:hrm_app/services/camera.service.dart';
import 'package:hrm_app/services/face_detector_service.dart';
import 'package:hrm_app/services/locator/locator.dart';
import 'package:hrm_app/services/ml_service.dart';
import 'package:hrm_app/utils/nav_utail.dart';

import 'components/camera_header.dart';

class FaceSignInScreen extends StatefulWidget {
  const FaceSignInScreen({Key? key}) : super(key: key);

  @override
  FaceSignInScreenState createState() => FaceSignInScreenState();
}

class FaceSignInScreenState extends State<FaceSignInScreen> {
  final CameraService _cameraService = locator<CameraService>();
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();
  final MLService _mlService = locator<MLService>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPictureTaken = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _faceDetectorService.initialize();
    setState(() => _isInitializing = false);
    _frameFaces();
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // prevents unnecessary overprocessing.
      processing = true;
      await _predictFacesFromImage(image: image);
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }
    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      await _cameraService.takePicture();

      setState(() => _isPictureTaken = true);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(content: Text('No face detected!')));
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }

  Future<void> onTap() async {
    await takePicture();
    if (_faceDetectorService.faceDetected) {
      bool? user = await _mlService.predict();
      if (user == true) {
        // _reload();
        Fluttertoast.showToast(msg: 'Successfully match');
        // if (mounted) {
        //   NavUtil.replaceScreen(
        //       context,
        //       Attendance(
        //         navigationMenu: false,
        //         selfie: _cameraService.imagePath,
        //       ));
        // }
      } else {
        _reload();
      }
    }
  }

  Future<void> onNavigateTap() async {
    if (mounted) {
      NavUtil.replaceScreen(
          context,
          Attendance(
            navigationMenu: false,
            selfie: _cameraService.imagePath,
          ));
    }
  }

  signSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              AppButton(
                text: 'Register Face',
                onPressed: () async {
                  // await _registerFace(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getBodyWidget() {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isPictureTaken) {
      return Column(children: [
        Expanded(child: SinglePicture(imagePath: _cameraService.imagePath!)),
        Container(
          padding: const EdgeInsets.all(18),
          height: 80,
            width: double.infinity,
            child: ElevatedButton(onPressed: () => onNavigateTap(), child: const Text('NEXT')))
      ]);
    }
    return CameraDetectionPreview();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("FACE MATCH", onBackPressed: _onBackPressed);
    Widget body = getBodyWidget();
    Widget? fab;
    if (!_isPictureTaken) fab = AuthButton(onTap: onTap);
    // if (_isPictureTaken) {
    //
    //   fab = AppButton(
    //     text: 'NEXT',
    //     onPressed: () => onNavigateTap(),
    //   );
    // }

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }
}
