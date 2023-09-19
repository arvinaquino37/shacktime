import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hrm_app/data/model/f_c_m_data_model.dart';
import 'package:hrm_app/screens/appFlow/home/appreciate_teammate/apreciate_teamate_provider.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance.dart';
import 'package:hrm_app/screens/appFlow/menu/leave/all_leave_request_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/leave/leave_calender/leave_calender_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/leave/leave_note/create_leave_request_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/leave/leave_request_details/leave_request_details_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/leave/leave_type/leave_type_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/menu_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/office_tab/change_password/change_password_profile_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/office_tab/edit_official_info/deartment_list/department_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/office_tab/edit_official_info/designation_list/designation_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/notice/notice_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/phonebook/phonebook_provider.dart';
import 'package:hrm_app/screens/appFlow/navigation_bar/bottom_nav_controller.dart';
import 'package:hrm_app/screens/auth/change_password/change_password_provider.dart';
import 'package:hrm_app/screens/auth/forget_password/forget_pass_provider.dart';
import 'package:hrm_app/screens/auth/login/login_provider.dart';
import 'package:hrm_app/utils/notification_service.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:hrm_app/utils/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'api_provider/api_provider.dart';
import 'api_service/connectivity/connectivity_status.dart';
import 'live_traking/hive/driver_location_model.dart';
import 'live_traking/hive/driver_location_provider.dart';
import 'live_traking/location_provider.dart';
import 'screens/appFlow/home/home_provider.dart';
import 'screens/auth/splash_screen/splash_screen.dart';
import 'services/locator/locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future openBox() async {
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(DriverLocationModelAdapter());
  await Hive.openBox<DriverLocationModel>(location);
}

void main() async {
  /// registered camera service for face detection
  setupServices();

  /// for play store and app store update dialog
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  ///initializeFirebaseAtStatingPoint
  await Firebase.initializeApp();

  // /// initial Firebase for topic notification
  // await FirebaseMessaging.instance.subscribeToTopic('onestHrm');

  // ///local notification initial method call
  // await NotificationService().init();
  // ///request for ios permission
  // await NotificationService().requestIOSPermissions();

  ///get device details information
  await getDeviceId();

  await openBox();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  ///top-level function
  ///to handle background messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('bn', 'BN'),
        Locale('ar', 'AR')
      ],
      path: 'assets/translations',
      saveLocale: true,
      // assetLoader: CsvAssetLoader(),
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()));
  configLoading();
}

Future<void> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    final result =
        '${iosDeviceInfo.name}-${iosDeviceInfo.model}-${iosDeviceInfo.identifierForVendor}';
    SPUtill.setValue(SPUtill.keyIosDeviceToken, result);
    // return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    final androidDeviceInfo = await deviceInfo.androidInfo;
    final result =
        '${androidDeviceInfo.brand}-${androidDeviceInfo.device}-${androidDeviceInfo.id}';
    SPUtill.setValue(SPUtill.keyAndroidDeviceToken, result);
    // final map = androidDeviceInfo.toMap();
    // print('Device Map: $map');
    // return androidDeviceInfo.androidId; // unique ID on Android
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.colorPrimary
    ..backgroundColor = Colors.transparent
    ..indicatorColor = AppColors.colorPrimary
    ..textColor = AppColors.colorPrimary
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[];
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavController()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ForgetPassProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProfileProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => DesignationProvider()),
        ChangeNotifierProvider(create: (_) => LeaveTypeProvider()),
        ChangeNotifierProvider(create: (_) => AllLeaveRequestProvider()),
        ChangeNotifierProvider(create: (_) => LeaveCalenderProvider()),
        ChangeNotifierProvider(create: (_) => CreateLeaveRequestProvider()),
        ChangeNotifierProvider(create: (_) => AppreciateTeammateProvider()),
        ChangeNotifierProvider(create: (_) => PhonebookProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MaterialApp(
        title: 'PRINZ/CREATION',
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/leave_details': (context) => const LeaveRequestDetails(),
          '/notice_screen': (context) => const NoticeScreen(),
          '/attendance': (context) => const Attendance(
                navigationMenu: false,
              )
        },
        theme: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.colorPrimary,
                ),
            textTheme: GoogleFonts.cairoTextTheme()),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: EasyLoading.init(),
      ),
    );
  }
}

///Handle background messaging service
///It must not be an anonymous function.
/// It must be a top-level function (e.g. not a class method which requires initialization).
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification?.title == null) {
    final encodedString = json.encode(message.data);

    ///data class which will parse convert message to model data
    FCMDataModel notification = FCMDataModel.fromJson(message.data);

    ///background notification handler
    if (notification.image == null) {
      await notificationPlugin.showNotification(
          title: notification.title ?? message.notification?.title,
          body: notification.body ?? message.notification?.body,
          payload: encodedString);
    } else {
      await notificationPlugin.showNotificationWithAttachment(
          title: notification.title ?? message.notification?.title,
          body: notification.body ?? message.notification?.body,
          image: notification.image,
          payload: encodedString);
    }
  }
}
