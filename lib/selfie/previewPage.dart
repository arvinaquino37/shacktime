import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/custom_widgets/custom_buttom.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance.dart';
import 'dart:math' as math;

import 'package:hrm_app/utils/nav_utail.dart';

class PreviewPage extends StatefulWidget {
  final XFile picture;

  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    const double mirror = math.pi;
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(widget.picture.path)),
            )),
        const SizedBox(height: 24),
        CustomButton(
          title: tr("next"),
          clickButton: () {
            NavUtil.navigateScreen(
                context,
                Attendance(
                  navigationMenu: false,
                  selfie: widget.picture.path,
                ));
          },
        ),
      ]),
    );
  }
}
