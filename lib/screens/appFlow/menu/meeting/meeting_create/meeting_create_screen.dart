import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/menu/meeting/meeting_create/meeting_create_provider.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

class MeetingCreateScreen extends StatelessWidget {
  final int? id;

  const MeetingCreateScreen({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return ChangeNotifierProvider(
      create: (context) => MeetingCreateProvider(),
      child: Consumer<MeetingCreateProvider>(
        builder: (BuildContext context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF00CCFF),
                        AppColors.colorPrimary,
                      ],
                      begin: FractionalOffset(3.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
              title:  Text(tr("create_meeting")),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextTitle(tr("title*")),

                      ///title field:-------------------------
                      buildTextFormField(
                          labelTitle: tr("enter_title"),
                          controller: provider.titleController),
                      const SizedBox(
                        height: 25,
                      ),

                      ///Description field:-------------------------
                      buildTextTitle('description'),
                      TextFormField(
                        controller: provider.descriptionController,
                        maxLines: 3,
                        keyboardType: TextInputType.name,
                        decoration:  InputDecoration(
                          hintText: tr("enter_description"),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      ///Date picker field:-------------------------
                      buildTextTitle('Date Schedule'),
                      Card(
                        child: InkWell(
                          onTap: () => provider.selectDate(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(provider.monthYear ?? 'Date'),
                                const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      ///Time picker field:-------------------------
                      ///Start and End time
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                 tr("start_time"),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  child: InkWell(
                                    onTap: () => provider.showTime(context, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(provider.startTime ??
                                              tr("start_time")),
                                          const Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  tr("end_time"),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  child: InkWell(
                                    onTap: () => provider.showTime(context, 1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(provider.endTime ?? tr("end_time")),
                                          const Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      buildTextTitle(tr("location*")),
                      buildTextFormField(
                          labelTitle: tr("Enter Location"),
                          controller: provider.locationController),

                      ///if user come from appointment List page
                      ///then id will be null
                      id == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                buildTextTitle(tr("meeting_with")),
                                Card(
                                  child: ListTile(
                                    onTap: () =>
                                        provider.getAllUserData(context),
                                    title: Text(provider.allUserData?.name! ??
                                        tr("add_a_Substitute")),
                                    subtitle: Text(
                                        provider.allUserData?.designation! ??
                                            tr("add_a_Designation")),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(provider
                                              .allUserData?.avatar! ??
                                          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                                    ),
                                    trailing: const Icon(Icons.edit),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                      children: List.generate(
                                          provider.userNames.length,
                                          (index) => Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFF00CCFF),
                                                      AppColors.colorPrimary,
                                                    ],
                                                    begin: FractionalOffset(
                                                        2.0, 0.0),
                                                    end: FractionalOffset(
                                                        0.0, 1.0),
                                                    stops: [0.0, 1.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Text(
                                                provider.userNames[index],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )))),
                                )
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 25,
                      ),
                       Text(
                        tr("attachment"),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            style: BorderStyle.solid,
                            width: 0.0,
                          ),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: InkWell(
                          onTap: () => provider.pickAttachmentImage(context),
                          child: DottedBorder(
                            color: const Color(0xffC7C7C7),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 16),
                            strokeWidth: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                const Icon(
                                  Icons.upload_file,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  tr("upload_your_file"),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      provider.attachmentPath != null
                          ? Image.file(
                              provider.attachmentPath!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            ///id is for user id
                            await provider.postCreateMeeting(context);
                          }
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00CCFF),
                                  AppColors.colorPrimary,
                                ],
                                begin: FractionalOffset(2.0, 0.0),
                                end: FractionalOffset(0.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child:  Center(
                              child: Text(
                            tr("create"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding buildTextTitle(title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  TextFormField buildTextFormField({
    controller,
    labelTitle,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "$labelTitle",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return tr("this_field_is_required");
        }
        return null;
      },
    );
  }
}
