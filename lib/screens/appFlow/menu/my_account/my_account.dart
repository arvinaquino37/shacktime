import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/myaccount_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/appreciate_tab/appreciate_tab.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/emergency_tab/emergency_tab.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/financial_tab/financial_tab.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/office_tab/office_tab.dart';
import 'package:hrm_app/screens/appFlow/menu/my_account/tab/personal_tab/personal_tab.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatelessWidget {
  final int? tabIndex;

  const MyAccount({Key? key, this.tabIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAccountProvider(),
        child: Consumer<MyAccountProvider>(
          builder: (context, provider, _) {
            return DefaultTabController(
                length: 5,
                initialIndex: tabIndex ?? 0,
                child: Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        isScrollable: true,
                        labelColor: Colors.white,
                        // unselectedLabelColor: Colors.black,
                        labelStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        tabs: [
                          Text(
                            tr("official"),
                            style: const TextStyle(fontFamily: 'cairo'),
                          ),
                          Text(
                            tr("personal"),
                            style: const TextStyle(fontFamily: 'cairo'),
                          ),
                          Text(
                            tr("financial"),
                            style: const TextStyle(fontFamily: 'cairo'),
                          ),
                          Text(
                            tr("emergency"),
                            style: const TextStyle(fontFamily: 'cairo'),
                          ),
                          Text(
                            tr("appreciate"),
                            style: const TextStyle(fontFamily: 'cairo'),
                          ),
                        ],
                      ),
                      automaticallyImplyLeading: true,
                      centerTitle: false,
                      title: Text(
                        tr("my_account"),
                        style: const TextStyle(color: AppColors.appBarColor),
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        OfficeTab(
                          officialInfo:
                              context.watch<MyAccountProvider>().officialInfo,
                        ),
                        PersonalTab(
                          personalInfo:
                              context.watch<MyAccountProvider>().personalInfo,
                        ),
                        FinancialTab(
                          financialInfo:
                              context.watch<MyAccountProvider>().financialInfo,
                        ),
                        EmergencyTeb(
                          emergencyInfo:
                              context.watch<MyAccountProvider>().emergencyInfo,
                        ),
                        const AppreciateTab(),
                      ],
                    )));
          },
        ));
  }
}
