import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrm_app/data/model/menu/menu_model.dart';
import 'package:hrm_app/data/server/respository/menu_repository.dart';
import 'package:hrm_app/screens/appFlow/home/break_time/break_time_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/appointment/appointment_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/daily_leave/daily_leave/daily_leave_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/expense_new/expense_list/expense_list.dart';
import 'package:hrm_app/screens/appFlow/menu/leave/leave_summary/leave_summary.dart';
import 'package:hrm_app/screens/appFlow/menu/meeting/meeting_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/notice/notice_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/phonebook/phonebook_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/reports/reports_screen/report_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/visit/visit_screen.dart';
import 'package:hrm_app/screens/face_recognition/face_match_scree.dart';
import 'package:hrm_app/screens/face_recognition/face_recognition_screen.dart';
import 'package:hrm_app/selfie/selfie_screen.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/shared_preferences.dart';

import '../../../data/server/respository/repository.dart';
import '../home/attendeance/attendance.dart';
import 'approval/approval.dart';
import 'support/support_ticket/support_screen.dart';

class MenuProvider extends ChangeNotifier {
  String? userName;
  String? userPhone;
  MenuModel? menuModel;
  List<Datum>? menuList;
  String? profileImage;
  String? attendanceMethod;
  bool? isFaceRegistered;

  // MenuProvider() {
  //   getUserData();
  //   getMenuList();
  //   getSettingBase();
  // }

  void loadMenu() {
    getUserData();
    getMenuList();
    getSettingBase();
  }

  void getUserData() async {
    userName = await SPUtill.getValue(SPUtill.keyName);
    profileImage = await SPUtill.getValue(SPUtill.keyProfileImage);
    notifyListeners();
  }

  getMenuList() async {
    final response = await MenuRepository.getAllMenu();
    if (response.httpCode == 200) {
      menuList = response.data!.data!.data;
    }
    notifyListeners();
  }

  getRoutSlag(context, String? name, isFaceRegistered) {
    debugPrint('isFaceRegistered $isFaceRegistered');
    switch (name) {
      case 'support':
        return NavUtil.navigateScreen(context, const SupportScreen());
      case 'attendance':
        return getAttendanceMethod(context);

      case 'notice':
        return NavUtil.navigateScreen(context, const NoticeScreen());
      case 'expense':
        // return NavUtil.navigateScreen(context, const ExpanseCategory());
        return NavUtil.navigateScreen(context, const ExpenseList());
      case 'leave':
        return NavUtil.navigateScreen(context, const LeaveSummary());
      case 'approval':
        return NavUtil.navigateScreen(context, const ApprovalScreen());
      // return NavUtil.navigateScreen(context, const ExpanseCategory());
      case 'phonebook':
        return NavUtil.navigateScreen(context, const PhonebookScreen());
      case 'visit':
        return NavUtil.navigateScreen(context, const VisitScreen());
      case 'appointments':
        return NavUtil.navigateScreen(context, const AppointmentScreen());
      case 'break':
        return NavUtil.navigateScreen(
            context,
            NavUtil.navigateScreen(
                context,
                const BreakTime(
                  diffTimeHome: '',
                  hourHome: 0,
                  minutesHome: 0,
                  secondsHome: 0,
                )));
      case 'feedback':
        return Fluttertoast.showToast(msg: 'feedback');
      case 'report':
        return NavUtil.navigateScreen(context, const ReportScreen());
      case 'meeting':
        return NavUtil.navigateScreen(context, const MeetingScreen());
      case 'daily-leave':
        return NavUtil.navigateScreen(context, const DailyLeave());
      default:
        return debugPrint('default');
    }
  }

  getSettingBase() async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      ///check user register their face or not
      ///if not then go to face register page
      attendanceMethod = apiResponse.data?.data?.attendanceMethod;
      isFaceRegistered = apiResponse.data?.data?.isFaceRegistered;
      debugPrint('attendance method: $attendanceMethod');
      notifyListeners();
    }
  }

  /// FACE_RECOGNITION='FR';
  /// SELFIE_ATTENDANCE='SF';
  /// BARCODE='QR';
  /// NORMAL = 'N';
  Future getAttendanceMethod(context) async {
    switch (attendanceMethod) {
      case 'SF':
        await availableCameras().then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (_) => SelfieScreen(cameras: value))));
        break;
      case 'FR':
        isFaceRegistered == true
            ? NavUtil.navigateScreen(context, const FaceSignInScreen())
            : NavUtil.navigateScreen(context, const FaceSignUpScreen());
        break;
      case 'N':
        NavUtil.navigateScreen(
            context,
            const Attendance(
              navigationMenu: false,
            ));
        break;
      default:
        NavUtil.navigateScreen(
            context,
            const Attendance(
              navigationMenu: false,
            ));
        break;
    }
  }
}
