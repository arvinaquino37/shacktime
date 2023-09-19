import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrm_app/screens/appFlow/menu/drawer/terms_conditions/terms_conditions_provider.dart';
import 'package:provider/provider.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => TermsConditionsProvider(),
    child: Consumer<TermsConditionsProvider>(
      builder: (context,provider,_){
        return Scaffold(
          appBar: AppBar(
            title:  Text(tr("terms_and_condition")),
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
    ),);
  }
}
