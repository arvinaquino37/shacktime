import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:shimmer/shimmer.dart';

class TodaySummary extends StatelessWidget {
  final HomeProvider? provider;

  const TodaySummary({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return provider?.todayData != null
        ? Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text(
              'today_summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: Colors.black,
                  letterSpacing: 0.5),
            ).tr(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE8E8E8),
              highlightColor: Colors.white,
              child: Container(
                  height: 14,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(
                        10), // radius of 10// green as background color
                  )),
            ),
          );
  }
}
