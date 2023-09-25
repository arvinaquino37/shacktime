import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CheckStatusSection2 extends StatefulWidget {
  const CheckStatusSection2({super.key, this.provider});

  final HomeProvider? provider;

  @override
  State<CheckStatusSection2> createState() => _CheckStatusSection2State();
}

class _CheckStatusSection2State extends State<CheckStatusSection2> {
  Duration duration = Duration();
  Timer? timer;
  bool isRunning = false;
  String tdata = DateFormat("hh:mm:ss a").format(DateTime.now());

  DateTime? time1;
  DateTime? time2;
  int time1InMinutes = 0;
  int time2InMinutes = 0;

  String currentTimeIn = '';
  String currentTimeOut = '';

  DateTime? timeIn;
  DateTime? timeOut;
  int differenceInMinutes = 0;

  String? saveTimeIn;
  String? saveTimeIn2;

  void startTimer() {
    if(!isRunning ){
      timer = Timer.periodic(Duration(seconds: 1), (timer) => addTime());
    }
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer(){
    // if(!isRunning){
    //   timer?.cancel();
    // }
    setState(() {
      timer?.cancel();
      isRunning = false;
    });
  }

  void addTime() {
    final addSecond = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecond;
      duration = Duration(seconds: seconds);
    });
  }

  void getTimeIn() {
    setState(() {
      timeIn = DateTime.now();
    });
    print('timeIn: ${timeIn}');
  }

  void getTimeOut() {
    setState(() {
      timeOut = DateTime.now();
    });
  }

  void calculateTimeDifference2() {
    if (saveTimeIn2 != null && timeOut != null) {
      final difference = timeOut!.difference(DateTime.parse(saveTimeIn2!));
      differenceInMinutes = difference.inMinutes;
    } else {
      setState(() {
        differenceInMinutes = 0;
      });
    }
  }

  void calculateTimeDifference() {
    if (time1 != null && time2 != null) {
      final difference = time2!.difference(time1!);
      time1InMinutes = difference.inMinutes;
      time2InMinutes = 0; // Reset time2 in minutes
    }
  }

  void getCurrentTimeIn() {
    // final now = DateTime.now();
    final now = DateFormat("hh:mm:ss a").format(DateTime.now());
    setState(() {
      currentTimeIn = now.toString();
    });
    print('getCurrentTimeIn: $currentTimeIn');
  }

  void getCurrentTimeOut() {
    // final now = DateTime.now();
    final now = DateFormat("hh:mm:ss a").format(DateTime.now());
    setState(() {
      currentTimeOut = now.toString();
    });
    print('getCurrentTimeOut $currentTimeOut');
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")} : ${minutes.toString().padLeft(2, "0")}';
  }

  Future<void> setData(value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('setData', value);
  }

  Future<void> getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      saveTimeIn = pref.getString('setData');
    });
    print('saveTimeIn: $saveTimeIn');
  }

  Future<void> setData2(DateTime value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('setData2', value.toIso8601String());
  }

  Future<DateTime> getData2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      saveTimeIn2 = prefs.getString('setData2');
    });
    print('saveTimeIn2: $saveTimeIn2');
    if (saveTimeIn2 != null) {
      return DateTime.parse(saveTimeIn2!);
    } else {
      // Handle the case where the DateTime has not been saved yet
      return DateTime.now(); // You can choose a default value or handle it differently
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData();
      getData2();
      calculateTimeDifference2();
    });
  }

  @override
  Widget build(BuildContext context) {

    return widget.provider?.isCheckIn != null
        ? Visibility(
      visible: widget.provider?.isCheckIn ?? false,
      child: Column(
        children: [
          /*Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
                onTap: () {
                  Provider.of<HomeProvider>(context, listen: false)
                      .loadHomeData(context);
                  widget.provider?.getAttendanceMethod(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          widget.provider?.checkStatus == "Check In"
                              ? 'assets/home_icon/in.svg'
                              : 'assets/home_icon/out.svg',
                          height: 40,
                          width: 40,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child:
                                  const CircularProgressIndicator()),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                widget.provider?.checkStatus == "Check In"
                                    ? "Start Time"
                                    : "Done For Today?",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 10),
                            Text(
                              widget.provider?.checkStatus ?? 'Check In',
                              style: const TextStyle(
                                  color: AppColors.colorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),*/
          SizedBox(
            height: 10,
          ),
          /*Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            provider?.checkStatus == "Check In"
                                ? 'assets/home_icon/clock.png'
                                : 'assets/home_icon/clock.png',
                            height: 40,
                            width: 40,
                            // placeholderBuilder: (BuildContext context) =>
                            //     Container(
                            //         padding: const EdgeInsets.all(30.0),
                            //         child: const CircularProgressIndicator()),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: QC - Tandang Sora'),
                              Text(
                                  provider?.checkStatus == "Check In"
                                      ? "Rendered Time"
                                      : "Rendered Time",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      letterSpacing: 0.5)),
                              // const SizedBox(height: 10),
                              ClockTimer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Time Clock',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          widget.provider?.checkStatus == "Check In"
                              ? 'assets/home_icon/clock.png'
                              : 'assets/home_icon/clock.png',
                          height: 40,
                          width: 40,
                          // placeholderBuilder: (BuildContext context) =>
                          //     Container(
                          //         padding: const EdgeInsets.all(30.0),
                          //         child: const CircularProgressIndicator()),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // buildTime(),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: widget.provider?.checkStatus != "Check In" ? null : (){
                                      Provider.of<HomeProvider>(context, listen: false).loadHomeData(context);
                                      widget.provider?.getAttendanceMethod(context);

                                      getCurrentTimeIn(); // time format
                                      getTimeIn(); // date and time
                                      setData(currentTimeIn);
                                      getData();

                                      setData2(timeIn!.toLocal());
                                      getData2();

                                    } ,
                                    child: Text('Time-in')),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: widget.provider?.checkStatus != "Check In" ? () {
                                      Provider.of<HomeProvider>(context, listen: false).loadHomeData(context);
                                      widget.provider?.getAttendanceMethod(context);
                                    } : null,
                                    child: Text('Time-out'))
                              ],
                            ),
                            Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                    BorderRadius.circular(16)),
                                child: Center(
                                    child: Text(
                                      'Location: QC - Tandang Sora',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                            Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.brown,
                                    borderRadius:
                                    BorderRadius.circular(16)),
                                child: Center(
                                    child: Text(
                                      'Store Hours: 11AM-11PM',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                            // const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                  child: Divider(color: Colors.grey[400])),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.7,
                                      // decoration:
                                      //     BoxDecoration(color: Colors.green),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Today\'s Schedule'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('9h 00m'),
                                                ],
                                              ),
                                            ],
                                          ))),
                                  Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                      child: Divider(
                        color: Colors.grey[400],
                      )),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(onPressed:
                          widget.provider?.checkStatus == "Check In" ? null : (){
                            getCurrentTimeOut();
                            getTimeOut();
                            calculateTimeDifference2();
                            setState(() { });
                          }, child: Text('See Rendered Time?'))),
                      SizedBox(width: 20,),
                      Text(differenceInMinutes == null ? 'Loading...' : getTimeString(differenceInMinutes), style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 5 ,),
                      Text('minutes', style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Text('Time-in : $saveTimeIn')
                ],
              ),
            ),
          ),
        ],
      ),
    )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: const Color(0xFFE8E8E8),
            highlightColor: Colors.white,
            child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(
                      10), // radius of 10// green as background color
                )),
          ),
        ],
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '${hour}:${minutes}:${seconds}',
      style: const TextStyle(
          color: AppColors.colorPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0.5),
    );
  }

}