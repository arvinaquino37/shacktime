import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance.dart';
import 'package:hrm_app/utils/nav_utail.dart';

import '../../utils/shared_preferences.dart';
import '../auth/splash_screen/splash_screen.dart';

class FaceRegistrationSuccess extends StatelessWidget {
  const FaceRegistrationSuccess({Key? key, this.faceImagePath})
      : super(key: key);
  final String? faceImagePath;

  @override
  Widget build(BuildContext context) {
    const double mirror = math.pi;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Transform(alignment: Alignment.center,
                transform: Matrix4.rotationY(mirror),
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: ClipOval(
                    child: Image.file(
                      File(faceImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Transform(
            //     alignment: Alignment.center,
            //     child: FittedBox(
            //       fit: BoxFit.cover,
            //       child: Image.file(File(faceImagePath!)),
            //     ),
            //     transform: Matrix4.rotationY(mirror)),
            const SizedBox(
              height: 10,
            ),
            const Text('Face Registration Successful'),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async{
                  await SPUtill.deleteKey(SPUtill.keyAuthToken);
                  await SPUtill.deleteKey(SPUtill.keyUserId);
                  await SPUtill.deleteKey(SPUtill.keyProfileImage);
                  await SPUtill.deleteKey(SPUtill.keyCheckInID);
                  await SPUtill.deleteKey(SPUtill.keyName);
                  await SPUtill.deleteKey(SPUtill.keyIsAdmin);
                  await SPUtill.deleteKey(SPUtill.keyIsHr);
                  NavUtil.pushAndRemoveUntil(context, const SplashScreen());
                },
                child: const Text('Done'))
          ],
        ),
      ),
    );
  }
}
