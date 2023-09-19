import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'event_cart_widgets.dart';

class TodaySummaryList extends StatelessWidget {
  final HomeProvider? provider;

  const TodaySummaryList({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return provider?.todayData != null
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
                children: List.generate(
              provider?.todayData?.length ?? 0,
              (index) => EventCard(
                data: provider!.todayData![index],
                onPressed: () => provider?.getRoutSlag(
                    context, provider?.todayData![index].slug),
              ),
            )),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 160.0,
                    height: 180.0,
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xFFE8E8E8),
                      highlightColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 2),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: const Color(0xFFE8E8E8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
