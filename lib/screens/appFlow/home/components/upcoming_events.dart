import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'holiday_card_widget.dart';

class UpcomingEvent extends StatelessWidget {
  final HomeProvider? provider;

  const UpcomingEvent({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return provider?.upcomingItems != null
        ? Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SvgPicture.asset(
                //   'assets/home_icon/upcoming_events_banner.svg',
                //   height: 185,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
                Image.asset(
                  'assets/images/new_Upcoming_Event.png',
                  height: 185,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('upcoming_events',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  letterSpacing: 0.5))
                          .tr(),
                      const Text('public_holiday_and_even',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: Color(0xFF555555),
                                  letterSpacing: 0.5))
                          .tr(),
                      const SizedBox(
                        height: 6,
                      ),
                      Column(
                        children: provider!.upcomingItems!
                            .map(
                              (e) => HolidayWidgets(upcomingItems: e),
                            )
                            .toList(),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFFE8E8E8),
                  highlightColor: Colors.white,
                  child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(
                            10), // radius of 10// green as background color
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE8E8E8),
                      highlightColor: Colors.white,
                      child: Container(
                          height: 14,
                          width: 130,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.circular(
                                10), // radius of 10// green as background color
                          )),
                    ),
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE8E8E8),
                      highlightColor: Colors.white,
                      child: Container(
                          height: 14,
                          width: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.circular(
                                10), // radius of 10// green as background color
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFFE8E8E8),
                  highlightColor: Colors.white,
                  child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(
                            10), // radius of 10// green as background color
                      )),
                ),
              ),
            ],
          );
  }
}
