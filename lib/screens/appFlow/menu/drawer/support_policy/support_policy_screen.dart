import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrm_app/screens/appFlow/menu/drawer/support_policy/support_policy_provider.dart';
import 'package:provider/provider.dart';

class SupportPolicyScreen extends StatelessWidget {
  const SupportPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SupportPolicyProvider(),
      child: Consumer<SupportPolicyProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title:  Text(tr("support_policy")),
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
