import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrm_app/screens/appFlow/home/components/upcoming_event_widgetg.dart';
import 'package:hrm_app/screens/appFlow/menu/meeting/meeting_create/meeting_create_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/meeting/meeting_details/meeting_details_screen.dart';
import 'package:hrm_app/screens/appFlow/menu/meeting/meeting_provider.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

import '../../navigation_bar/buttom_navigation_bar.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MeetingProvider(),
      child: Consumer<MeetingProvider>(
        builder: (context, provider, _) {
          return WillPopScope(
            onWillPop: ()async{
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const ButtomNavigationBar(
                          bottomNavigationIndex: 0)),
                      (Route<dynamic> route) => false);
              return true;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                provider.getMeetingList();
              },
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => NavUtil.replaceScreen(
                      context, const MeetingCreateScreen()),
                  child: const Icon(Icons.add),
                ),
                appBar: AppBar(
                  title:  Text(tr("meeting_List")),
                ),
                body: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            provider.selectDate(context);
                          },
                          icon: const FaIcon(FontAwesomeIcons.angleLeft,
                              size: 30, color: AppColors.colorPrimary),
                        ),
                        const Spacer(),
                        Center(
                            child: Text(
                          "${provider.monthYear}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            provider.selectDate(context);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.angleRight,
                            size: 30,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ],
                    ),
                    provider.isLoading == true
                        ? provider.responseMeetingList!.data!.items!.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: provider.responseMeetingList?.data
                                          ?.items?.length ??
                                      0,
                                  itemBuilder: (BuildContext context, int index) {
                                    final data = provider
                                        .responseMeetingList?.data?.items?[index];
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: InkWell(
                                          onTap: () => NavUtil.navigateScreen(
                                              context,
                                              MeetingDetailsScreen(
                                                meetingId: data?.id,
                                              )),
                                          child: EventWidgets(
                                              isAppointment: true, data: data!),
                                        ));
                                  },
                                ),
                              )
                            :  Expanded(
                                child: Center(
                                    child: Text(
                                  tr("no_meeting_found"),
                                  style: const TextStyle(
                                      color: Color(0x65555555),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                )),
                              )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
