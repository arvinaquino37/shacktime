import 'package:flutter/foundation.dart';
import 'package:hrm_app/screens/appFlow/navigation_bar/buttom_navigation_bar.dart';
import 'package:hrm_app/screens/auth/login/login_screen.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/shared_preferences.dart';

class SplashProvider extends ChangeNotifier{
  // bool isValid = false;
  SplashProvider(context){
    // getToken(context);
    initFunction(context);
  }

  initFunction(context){
    Future.delayed(const Duration(seconds: 2), () async {
      var token = await SPUtill.getValue(SPUtill.keyAuthToken);
      var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
      if (kDebugMode) {
        /// development purpose only
        print("Bearer token: $token");
        print("User Id: $userId");
      }
      if (token != null) {
        NavUtil.replaceScreen(context, const ButtomNavigationBar());
      } else {
        NavUtil.replaceScreen(context, const LoginScreen());
      }
      notifyListeners();
    });
  }

  // /// getToken API .............
  // void getToken(context) async {
  //   var token = await SPUtill.getValue(SPUtill.keyAuthToken);
  //   var bodyToken = BodyToken(
  //       token: token
  //   );
  //   var apiResponse = await Repository.validTokenApi(bodyToken);
  //   if (apiResponse.result == true) {
  //     isValid = true;
  //     initFunction(context);
  //     notifyListeners();
  //   } else {
  //     isValid = false;
  //     notifyListeners();
  //   }
  //
  // }
}