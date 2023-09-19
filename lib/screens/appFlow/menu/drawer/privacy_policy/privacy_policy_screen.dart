import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrm_app/screens/appFlow/menu/drawer/privacy_policy/privacy_policy_provider.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrivacyPolicyProvider(),
      child: Consumer<PrivacyPolicyProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title:  Text(tr("privacy_policy")),
            ),
            body: SingleChildScrollView(
                child: provider.contentsData != null
                    ? Html(
                        data: provider
                            .contentsData?.data?.contents?.first.content,
                        shrinkWrap: true,
                      )
                    : const SizedBox()),
          );
        },
      ),
    );
  }
}
