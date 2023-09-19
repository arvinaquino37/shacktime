import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/api_provider/api_provider.dart';
import 'package:hrm_app/api_service/connectivity/no_internet_screen.dart';
import 'package:hrm_app/screens/appFlow/home/components/appointment_card.dart';
import 'package:hrm_app/screens/appFlow/home/components/appreciate_card.dart';
import 'package:hrm_app/screens/appFlow/home/components/break_section.dart';
import 'package:hrm_app/screens/appFlow/home/components/check_status_section.dart';
import 'package:hrm_app/screens/appFlow/home/components/current_month.dart';
import 'package:hrm_app/screens/appFlow/home/components/today_summary.dart';
import 'package:hrm_app/screens/appFlow/home/components/today_summary_list.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:hrm_app/utils/notification_service.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

import '../../../live_traking/location_provider.dart';
import 'components/greetings_section.dart';
import 'components/upcoming_events.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<ApiProvider>();
    final provider = context.watch<HomeProvider>();
    notificationPlugin.scheduleNotification(
        0,
        tr("attendance_alert"),
        tr("good_morning_have_you_checked_in_office_yet"),
        settingProvider.inHour ?? 10,
        settingProvider.inMin ?? 0,
        settingProvider.inSec ?? 0);
    notificationPlugin.scheduleNotification(
        1,
        tr("check_out_alert"),
        tr("good_evening_have_you_checked_out_office_yet"),
        settingProvider.outHour ?? 18,
        settingProvider.outMin ?? 0,
        settingProvider.outSec ?? 0);

    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child:
          Consumer<LocationProvider>(builder: (context, locationProvider, _) {
        return NoInternetScreen(
            child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => provider.loadHomeData(context),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  ///blue background
                  Positioned(
                    right: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/__home_background.png',
                      fit: BoxFit.cover,
                      // color: AppColors.colorPrimary,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),

                          /// Greetings Section ==========================
                          GreetingsSection(
                            provider: provider,
                          ),
                          const SizedBox(height: 16),

                          /// Today Summary Text =========================
                          TodaySummary(
                            provider: provider,
                          ),
                          const SizedBox(height: 8),

                          ///Today Summary List ==========================
                          TodaySummaryList(
                            provider: provider,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      ///Check In Check Out here:-------------------------
                      CheckStatusSection(
                        provider: provider,
                      ),

                      ///Break In Out from here:--------------------------
                      BreakSection(
                        provider: provider,
                      ),

                      ///upcoming events:----------------------
                      UpcomingEvent(provider: provider),

                      ///=========== Appointments ============
                      provider.appointmentsItems != null &&
                              provider.appointmentsItems!.isNotEmpty
                          ? AppointmentCard(
                              provider: provider,
                            )
                          : const SizedBox(
                              height: 0,
                            ),

                      ///  ================ Appreciated Card UI ==========
                      const AppreciateCard(),

                      /// ============== Current Month ========
                      CurrentMonth(
                        provider: provider,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      }),
    );
  }
}
