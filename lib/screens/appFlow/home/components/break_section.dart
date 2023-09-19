import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/break_time/break_time_screen.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:lottie/lottie.dart';

class BreakSection extends StatelessWidget {
  final HomeProvider? provider;

  const BreakSection({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: provider?.isBreak ?? false,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            NavUtil.navigateScreen(
                context,
                const BreakTime(
                  diffTimeHome: '',
                  hourHome: 0,
                  minutesHome: 0,
                  secondsHome: 0,
                ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Lottie.asset('assets/images/tea_time.json',
                      height: 65, width: 65),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('break_time',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  letterSpacing: 0.5))
                          .tr(),
                      const SizedBox(height: 10),
                      const Text(
                        'start_break',
                        style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            letterSpacing: 0.5),
                      ).tr(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
