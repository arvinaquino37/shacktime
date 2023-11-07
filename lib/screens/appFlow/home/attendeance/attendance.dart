import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrm_app/api_service/connectivity/no_internet_screen.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance_provider.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance_report/attendence_report.dart';
import 'package:hrm_app/screens/appFlow/navigation_bar/buttom_navigation_bar.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

class Attendance extends StatefulWidget {
  final bool? navigationMenu;
  final String? qrData;
  final String? selfie;

  const Attendance({Key? key, this.navigationMenu, this.qrData, this.selfie})
      : super(key: key);

  static const String routeName = '/attendance';

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  late AnimationController controller;

  List<String> branchName = ['MC Malabon City', 'Fisher Mall Malabon (Sun-Thurs)', 'Fisher Mall Malabon (Fri-Sat)', 'Puregold Navotas', 'Sampaguita Navotas'];
  List<String> operatingHours = ['9:30-8:00', '9:30-9:00', '9:30-10:00', '8:30-9:00', '9:30-9:30'];
  String? selectedBranchName;
  String? selectedOperatingHours;

  List jsonData = [];
  String? valueChoose;
  String? storeHours;

  bool isLocation = false;

  Future<void> loadJsonData() async {
    //   final String jsonString = await DefaultAssetBundle.of(context)
    //       .loadString('assets/json/store.json'); // Change the path as per your JSON file location
    //   final List<dynamic> data = json.decode(jsonString);
    //   setState(() {
    //     jsonData = data.cast<Map<String, dynamic>>();
    //   });
    // }

    // Load the JSON file from assets
    final String jsonString = await rootBundle.loadString('assets/json/store.json');
    // final jsonString = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    // Parse the JSON string into a List
    // final List<Map<String, dynamic>> data = json.decode(jsonString);
    // List<Map<String, dynamic>> jsonData = [];
    final data = await json.decode(jsonString);
    // final data = await json.decode(jsonString.body);
    // Map jsonStore = jsonDecode(jsonString);

    setState(() {
      jsonData = data["store"];
      // jsonData = data;
    });

    // return jsonStore;
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        animationBehavior: AnimationBehavior.preserve);
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    ui.TextDirection direction = ui.TextDirection.ltr;
    return NoInternetScreen(
      child: ChangeNotifierProvider<AttendanceProvider>(
        create: (context) => AttendanceProvider(controller, context),
        child: Consumer<AttendanceProvider>(
          builder: (context, provider, _) {
            provider.qrCode = widget.qrData;
            provider.selfie = widget.selfie;

            return WillPopScope(
              onWillPop: () async {
                if (widget.navigationMenu == true) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                          const ButtomNavigationBar(
                              bottomNavigationIndex: 2)),
                          (Route<dynamic> route) => false);
                  return true;
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                          const ButtomNavigationBar(
                              bottomNavigationIndex: 0)),
                          (Route<dynamic> route) => false);
                  return true;
                }
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  flexibleSpace: provider.checkIn != null
                      ? Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFF00CCFF),
                            AppColors.colorPrimary,
                          ],
                          begin: FractionalOffset(3.0, 0.0),
                          end: FractionalOffset(0.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  )
                      : Shimmer.fromColors(
                    baseColor: const Color(0xFFE8E8E8),
                    highlightColor: Colors.white,
                    child: Container(
                        height: 120,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(
                              0), // radius of 10// green as background color
                        )),
                  ),
                  title: Text(
                    tr('attendance'),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBarColor),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        NavUtil.navigateScreen(
                            context, const AttendenceReport());
                      },
                      child: Row(
                        children: [
                          Lottie.asset(
                            'assets/images/ic_report_lottie.json',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                body: Center(
                  child: ListView(
                    children: [
                      Opacity(
                        opacity: provider.isIPEnabled ?? 1,
                        child: Visibility(
                          visible: provider.isCheckIn ?? true,
                          child: Column(
                            children: [
                              provider.checkIn != null
                                  ? Container(
                                color: const Color(0xffB7E3E8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                          'assets/images/map_marker_icon.json',
                                          height: 35,
                                          width: 35),
                                      Expanded(
                                        child: SizedBox(
                                          child: Text(
                                            "${provider.isLoading
                                                ? "Loading..."
                                                : provider.youLocationServer}",
                                            style: GoogleFonts.lato(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 12,
                                                color: const Color(
                                                    0xFF404A58)),
                                            maxLines: 2,
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await context
                                              .read<AttendanceProvider>()
                                              .updatePosition();
                                              setState(() {
                                                provider.youLocationServer == 'Loading...';
                                              });
                                              
                                        },
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 14,
                                              backgroundColor:
                                              AppColors.colorPrimary,
                                              child: Center(
                                                child: Lottie.asset(
                                                  'assets/images/Refresh.json',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              tr("refresh"),
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .colorPrimary,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 70,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          0), // radius of 10// green as background color
                                    )),
                              ),
                              Visibility(
                                visible: provider.checkStatus == 'Check In' ? true : false,
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.green)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Store Location: '),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                              child: DropdownButton<String>(
                                                underline: SizedBox(),
                                                isDense: false,
                                                hint: Text('Select Branch:'),
                                                value: valueChoose,
                                                onChanged: (value) {
                                                  setState(() {
                                                    valueChoose = value;
                                                    // Find the selected object's description
                                                    for (var obj in jsonData) {
                                                      if (obj['store_location'] == value) {
                                                        storeHours = obj['store_time'];
                                                        break;
                                                        }
                                                      }
                                                   });
                                                        },
                                                        items: jsonData.map((valueItem){
                                                          return DropdownMenuItem<String>(
                                                            child: Text(valueItem['store_location'],style: TextStyle(fontSize: 14)),
                                                            value: valueItem['store_location'],);
                                                          // child: Text(valueItem['title'],style: TextStyle(fontSize: 14)),
                                                          // value: valueItem['title'],);
                                                        }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text('Operating Hours: ${storeHours == null ? 'Please Select Store Location' : storeHours}'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              provider.checkIn != null
                                  ? Text(tr("choose_your_remote_mode"),
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold))
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          10), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              provider.checkIn != null
                                  ? SizedBox(
                                height: 42,
                                child: ToggleSwitch(
                                  minWidth: 110.0,
                                  borderColor: const [
                                    AppColors.colorPrimary,
                                  ],
                                  borderWidth: 3,
                                  cornerRadius: 30.0,
                                  activeBgColors: const [
                                    [Colors.white],
                                    [Colors.white]
                                  ],
                                  activeFgColor: AppColors.colorPrimary,
                                  inactiveBgColor: AppColors.colorPrimary,
                                  inactiveFgColor: Colors.white,
                                  initialLabelIndex:
                                  provider.remoteModeType,
                                  icons: const [
                                    FontAwesomeIcons.house,
                                    FontAwesomeIcons.building
                                  ],
                                  totalSwitches: 2,
                                  labels: [
                                    ' ${tr("home")}',
                                    (tr("office"))
                                  ],
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    /// RemoteModeType
                                    /// 0 ==> Home
                                    /// 1 ==> office
                                    provider.remoteModeType = index;
                                  },
                                ),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 42,
                                    width: 230,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          30), // radius of 10// green as background color
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: provider.isIPEnabled ?? 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            provider.checkIn != null
                                ? Directionality(
                              textDirection: direction,
                              child: DigitalClock(
                                digitAnimationStyle: Curves.decelerate,
                                is24HourTimeFormat: false,
                                areaDecoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.transparent),
                                ),
                                hourMinuteDigitTextStyle: const TextStyle(
                                  color: Color(0xFF404A58),
                                  fontSize: 50,
                                ),
                                amPmDigitTextStyle: const TextStyle(
                                    color: Color(0xFF404A58),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                                : Shimmer.fromColors(
                              baseColor: const Color(0xFFE8E8E8),
                              highlightColor: Colors.white,
                              child: Container(
                                  height: 60,
                                  width: 230,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E8E8),
                                    borderRadius: BorderRadius.circular(
                                        5), // radius of 10// green as background color
                                  )),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            provider.checkIn != null
                                ? Text(
                              "${provider.currentDate}",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 20,
                                  color: const Color(0xFF404A58)),
                            )
                                : Shimmer.fromColors(
                              baseColor: const Color(0xFFE8E8E8),
                              highlightColor: Colors.white,
                              child: Container(
                                  height: 24,
                                  width: 230,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E8E8),
                                    borderRadius: BorderRadius.circular(
                                        10), // radius of 10// green as background color
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: provider.youLocationServer == 'Loading...' ? CircularProgressIndicator() : GestureDetector(
                          onVerticalDragCancel: () {
                            controller.reset();
                          },
                          onHorizontalDragCancel: () {
                            controller.reset();
                          },
                          onTapDown: (_) {
                            controller.forward();
                          },
                          onTapUp: (_) {
                            if (controller.status ==
                                AnimationStatus.forward) {
                              controller.reverse();
                              controller.value;
                            }
                          },
                          child: provider.checkIn != null
                              ? Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 175,
                                width: 175,
                                child: CircularProgressIndicator(
                                  // strokeWidth: 5,
                                  value: 1.0,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              Container(
                                height: 185,
                                width: 185,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(
                                      Radius.circular(100.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.colorPrimary
                                            .withOpacity(0.1),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3),
                                      )
                                    ]),
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  value: controller.value,
                                  valueColor: AlwaysStoppedAnimation<
                                      Color>(
                                      provider.checkStatus == "Check In"
                                          ? AppColors.colorPrimary
                                          : const Color(0xFFD83675)),
                                ),
                              ),
                              ClipOval(
                                child: Material(
                                    child: Container(
                                      height: 170,
                                      width: 170,
                                      decoration: provider.checkStatus ==
                                          "Check Out"
                                          ? const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              //     ? const Color(0xFF4D4AB6)
                                              // : const Color(0xFFD83675)),
                                              Color(0xFFE8356C),
                                              AppColors.colorPrimary,
                                            ],
                                            begin: FractionalOffset(
                                                1.0, 0.0),
                                            end: FractionalOffset(
                                                0.0, 3.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      )
                                          : const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              AppColors.colorPrimary,
                                              Color(0xFF00CCFF)
                                            ],
                                            begin: FractionalOffset(
                                                1.0, 0.0),
                                            end: FractionalOffset(
                                                0.0, 3.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Image.asset(
                                                "assets/images/tap_figer.png",
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text(
                                                tr(provider.checkStatus ??
                                                    "check In"),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          )
                              : Shimmer.fromColors(
                            baseColor: const Color(0xFFE8E8E8),
                            highlightColor: Colors.white,
                            child: Container(
                                height: 184,
                                width: 184,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(
                                      100), // radius of 10// green as background color
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              provider.checkIn != null
                                  ? const Icon(
                                Icons.watch_later_outlined,
                                color: AppColors.colorPrimary,
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              provider.checkIn != null
                                  ? Text(
                                provider.inTime ?? "--:--",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              provider.checkIn != null
                                  ? Text(
                                tr("check_in"),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              provider.checkIn != null
                                  ? const Icon(
                                Icons.watch_later_outlined,
                                color: AppColors.colorPrimary,
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              provider.checkIn != null
                                  ? Text(
                                provider.outTime ?? "--:--",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              provider.checkIn != null
                                  ? Text(
                                tr("check_out"),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              provider.checkIn != null
                                  ? const Icon(
                                Icons.history,
                                color: AppColors.colorPrimary,
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              provider.checkIn != null
                                  ? Text(
                                provider.stayTime ?? "--:--",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              provider.checkIn != null
                                  ? Text(
                                tr("working_hr"),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              )
                                  : Shimmer.fromColors(
                                baseColor: const Color(0xFFE8E8E8),
                                highlightColor: Colors.white,
                                child: Container(
                                    height: 14,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(
                                          101), // radius of 10// green as background color
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
