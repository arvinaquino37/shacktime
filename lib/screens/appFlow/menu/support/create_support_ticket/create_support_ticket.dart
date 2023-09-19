import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/custom_widgets/custom_buttom.dart';
import 'package:hrm_app/screens/appFlow/menu/support/create_support_ticket/create_support_ticket_provider.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

class CreateSupportTicket extends StatelessWidget {
  const CreateSupportTicket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateSupportTicketProvider(),
      child: Consumer<CreateSupportTicketProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                tr("create_support_ticket"),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold,color: AppColors.appBarColor),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      tr("priority"),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                  value: "High",
                                  groupValue: provider.selectedPriority,
                                  onChanged: (String? genderValue) {
                                    if (kDebugMode) {
                                      print("Radio $genderValue");
                                    }
                                    provider.genderSelectedValue(genderValue!);
                                    provider.genderType(genderValue);
                                  }),
                               Text(
                                tr("high"),
                                style:const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                  value: "Medium",
                                  groupValue: provider.selectedPriority,
                                  onChanged: (String? genderValue) {
                                    if (kDebugMode) {
                                      print("Radio $genderValue");
                                    }
                                    provider.genderSelectedValue(genderValue!);
                                    provider.genderType(genderValue);
                                  }),
                               Text(
                               tr("medium") ,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                  value: "Low",
                                  groupValue: provider.selectedPriority,
                                  onChanged: (String? genderValue) {
                                    if (kDebugMode) {
                                      print("Radio $genderValue");
                                    }
                                    provider.genderSelectedValue(genderValue!);
                                    provider.genderType(genderValue);
                                  }),
                               Text(
                                tr("low"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Text(
                      tr("subject"),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: provider.subjectTextController,
                      keyboardType: TextInputType.name,
                      decoration:  InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: tr("write_subject"),
                        hintStyle: const TextStyle(fontSize: 14),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: provider.errorSubject != null,
                        child: Text(
                          provider.errorSubject ?? "",
                          style: const TextStyle(color: Colors.red),
                        )),
                    Visibility(
                        visible: provider.errorMessage != null &&
                            provider.errorSubject == null &&
                            provider.errorDescription == null,
                        child: Text(
                          provider.errorMessage ?? "",
                          style: const TextStyle(color: Colors.red),
                        )),

                    const SizedBox(
                      height: 16,
                    ),
                     Text(
                      tr("what_support_do_you_need?"),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: provider.descriptionTextController,
                      maxLines: 5,
                      keyboardType: TextInputType.name,
                      decoration:  InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: tr("write_description"),
                        hintStyle: const TextStyle(fontSize: 14),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: provider.errorDescription != null,
                        child: Text(
                          provider.errorDescription ?? "",
                          style: const TextStyle(color: Colors.red),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () {
                        provider.pickAttachmentImage(context);
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            style: BorderStyle.solid,
                            width: 0.0,
                          ),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: DottedBorder(
                          color: const Color(0xffC7C7C7),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(3),
                          strokeWidth: 2,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                const Icon(
                                  Icons.upload_file,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  tr("add_file"),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: provider.attachmentPath == null
                          ? const SizedBox()
                          : Image.file(
                              provider.attachmentPath!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      title: tr("submit"),
                      clickButton: () {
                        provider.supportCreateApi(context);
                      },
                    ),
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
