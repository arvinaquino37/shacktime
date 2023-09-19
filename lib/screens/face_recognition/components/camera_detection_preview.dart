import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/face_recognition/components/FacePainter.dart';
import 'package:hrm_app/services/camera.service.dart';
import 'package:hrm_app/services/face_detector_service.dart';
import 'package:hrm_app/services/locator/locator.dart';

class CameraDetectionPreview extends StatelessWidget {
  CameraDetectionPreview({Key? key}) : super(key: key);

  final CameraService _cameraService = locator<CameraService>();
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Transform.scale(
      scale: 1.0,
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: SizedBox(
              width: width,
              height:
                  width * _cameraService.cameraController!.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[

                  CameraPreview(_cameraService.cameraController!),
                  if (_faceDetectorService.faceDetected)
                    CustomPaint(
                      painter: FacePainter(
                        face: _faceDetectorService.faces[0],
                        imageSize: _cameraService.getImageSize(),
                      ),
                    ),

                  Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      "assets/images/face.png",fit: BoxFit.contain,
                    ),
                  ),

                  // Center(
                  //   child: Container(
                  //     height: height * 0.4,
                  //     width: width * 0.6,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.white, width: 4),
                  //
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
