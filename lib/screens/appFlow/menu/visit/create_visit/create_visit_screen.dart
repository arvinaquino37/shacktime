import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/custom_widgets/custom_buttom.dart';
import 'package:hrm_app/screens/appFlow/menu/visit/create_visit/create_visit_provider.dart';
import 'package:provider/provider.dart';

class CreateVisitScreen extends StatelessWidget {
  const CreateVisitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateVisitProvider(),
      child: Consumer<CreateVisitProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title:  Text(
                tr("create_visit"),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4),
                          child: Text(
                            tr("employee"),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title:
                                Text(provider.officialInfo?.data?.name ?? ""),
                            subtitle: Text(
                                provider.officialInfo?.data?.designation ?? ""),
                            leading: ClipOval(
                              child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                imageUrl: "${provider.officialInfo?.data?.avatar}",
                                placeholder: (context, url) => Center(
                                  child: Image.asset("assets/images/placeholder_image.png"),
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4),
                          child: Text(
                            tr("date*"),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        InkWell(
                          onTap: () => provider.selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${provider.selectedDate.toLocal()}"
                                    .split(' ')[0]),
                                const Icon(Icons.date_range_outlined)
                              ],
                            ),
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4),
                          child: Text(
                            tr("title*"),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        TextFormField(
                          controller: provider.visitTitleTextController,
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          decoration:  InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: tr("give_a_title_to_your_visit"),
                            hintStyle: const TextStyle(fontSize: 14),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return tr("this_field_is_required");
                            }
                            return null;
                          },
                        ),
                        Visibility(
                            visible: provider.titleError != null,
                            child: Text(
                              provider.titleError ?? "",
                              style: const TextStyle(color: Colors.red),
                            )),
                        Visibility(
                            visible: provider.errorMassage != null &&
                                provider.titleError == null,
                            child: Text(
                              provider.errorMassage ?? "",
                              style: const TextStyle(color: Colors.red),
                            )),
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4),
                          child: Text(
                            tr("description_optional"),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        TextField(
                          controller: provider.visitDescriptionTextController,
                          maxLines: 5,
                          keyboardType: TextInputType.name,
                          decoration:  InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: tr("write_a_note"),
                            hintStyle: const TextStyle(fontSize: 14),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomButton(
                    title: tr("create_visit"),
                    clickButton: () {
                      provider.getCreateVisit(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
