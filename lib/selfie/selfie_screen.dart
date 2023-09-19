import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/selfie/previewPage.dart';

class SelfieScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const SelfieScreen({Key? key, this.cameras}) : super(key: key);

  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  late CameraController _cameraController;

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![1]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          (_cameraController.value.isInitialized)
              ? CameraPreview(_cameraController)
              : Container(
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  color: Colors.black),
              child:
                  IconButton(
                    onPressed: takePicture,
                    iconSize: 80,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.circle, color: Colors.white),
                  ),
            ),
          ),
        ]),
      ),
    );
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewPage(
                      picture: picture,
                    )));
      }
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }
}
