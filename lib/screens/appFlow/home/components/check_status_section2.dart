import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return widget.provider?.isCheckIn != null
        ? Visibility(
      visible: widget.provider?.isCheckIn ?? false,
      child: Column(
        children: [
          Card(
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
          ),
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
                                buildTime(),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: isRunning ? null : () => startTimer(),
                                    child: Text('Time-in')),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: isRunning ? () => stopTimer() : null,
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
                                  Icon(Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ],
                          )),
                    ],
                  )
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