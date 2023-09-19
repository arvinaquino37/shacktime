import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrm_app/api_service/api_body.dart';
import 'package:hrm_app/data/model/auth_response/response_login.dart';
import 'package:hrm_app/data/server/respository/auth_repository/auth_repository.dart';
import 'package:hrm_app/data/server/respository/repository.dart';
import 'package:hrm_app/permission/app_permission_page.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import '../../appFlow/navigation_bar/buttom_navigation_bar.dart';

class LoginProvider extends ChangeNotifier {
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  String? email;
  String? password;
  String? error;
  bool isError = false;
  bool passwordVisible = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  loc.Location location = loc.Location();

  LoginProvider() {
    passwordVisible = false;
  }

  // Future checkGps(context) async {
  //   ///check permission
  //   location.hasPermission().then((permissionGrantedResult) {
  //     if (permissionGrantedResult != loc.PermissionStatus.granted &&
  //         Platform.isAndroid) {
  //       _neverSatisfied(context);
  //     }
  //   });
  //
  //   notifyListeners();
  // }

  Future checkGps(context) async {
    var permissionGranted;
    if (await Permission.location.request().isGranted) {
      permissionGranted = true;
      _neverSatisfied(context);
    } else if (await Permission.location.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.location.request().isDenied) {
      permissionGranted = false;
      await openAppSettings();
    }
  }

  Future<void> _neverSatisfied(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'You have to grant background location permission.',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  prominentDisclosure,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(
                  height: 36.0,
                ),
                Text(denyMessage),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                locationPermission(context);
              },
              child: const Text('Next'),
            ),
            MaterialButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String denyMessage =
      'If the permission is rejected, then you have to manually go to the settings to enable it';
  String prominentDisclosure =
      'Blistavi Dom collects location data to enable user employee attendance and visit feature, also find distance between employee and office position for accurate daily attendance ';

  passwordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void resetTextField() {
    emailTextController.text = "";
    passwordTextController.text = "";
    email = "";
    password = "";
    error = "";
    notifyListeners();
  }

  void setDataSharePreferences(ResponseLogin? responseLogin) {
    SPUtill.setValue(SPUtill.keyAuthToken, responseLogin?.data?.token);
    SPUtill.setIntValue(SPUtill.keyUserId, responseLogin?.data?.id);
    SPUtill.setValue(SPUtill.keyProfileImage, responseLogin?.data?.avatar);
    SPUtill.setValue(SPUtill.keyName, responseLogin?.data?.name);
    SPUtill.setBoolValue(SPUtill.keyIsAdmin, responseLogin?.data?.isAdmin);
    SPUtill.setBoolValue(SPUtill.keyIsHr, responseLogin?.data?.isHr);
  }

  void getUserInfo(context) async {
    var bodyLogin = BodyLogin(
        email: emailTextController.text, password: passwordTextController.text);
    var apiResponse = await AuthRepository.getLogin(bodyLogin);
    if (apiResponse.result == true) {
      getBaseSetting();
      setDataSharePreferences(apiResponse.data);
      Fluttertoast.showToast(
          msg: apiResponse.message ?? "",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      resetTextField();
      if (Platform.isAndroid) {
        checkGps(context);
        NavUtil.replaceScreen(context, const ButtomNavigationBar());
      } else {
        NavUtil.replaceScreen(context, const AppPermissionPage());
      }
    } else {
      if (apiResponse.httpCode == 422) {
        email = apiResponse.error?.laravelValidationError?.email;
        password = apiResponse.error?.laravelValidationError?.password;
        error = apiResponse.message;
        notifyListeners();
      } else if (apiResponse.httpCode == 400) {
        email = apiResponse.error?.laravelValidationError?.email;
        password = apiResponse.error?.laravelValidationError?.password;
        error = apiResponse.message;
        notifyListeners();
      } else if (apiResponse.httpCode == 403) {
        email = apiResponse.error?.laravelValidationError?.email;
        password = apiResponse.error?.laravelValidationError?.password;
        error = apiResponse.message;
        notifyListeners();
      } else if (apiResponse.httpCode == 401) {
        email = apiResponse.error?.laravelValidationError?.email;
        password = apiResponse.error?.laravelValidationError?.password;
        error = apiResponse.message;
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: "Something Went Wrong");
      }
    }
  }

  getBaseSetting() async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      notifyListeners();
    }
  }

  locationPermission(context) async {
    ///request  permission
    await location.requestPermission();

    ///instantiate locationService
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
    Navigator.pop(context);
  }
}
