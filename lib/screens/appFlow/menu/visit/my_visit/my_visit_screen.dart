import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/menu/visit/my_visit/my_visit_provider.dart';
import 'package:hrm_app/screens/appFlow/menu/visit/visit_details/visit_details.dart';
import 'package:hrm_app/utils/nav_utail.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';

class MyVisitScreen extends StatelessWidget {
  const MyVisitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyVisitProvider(),
      child: Consumer<MyVisitProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              provider.isLoading
                  ? provider.visitList!.data!.myVisits!.isNotEmpty
                      ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                provider.visitList?.data?.myVisits?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      NavUtil.navigateScreen(
                                          context,
                                          VisitDetails(
                                              visitID: provider.visitList?.data
                                                  ?.myVisits?[index].id));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 5),
                                      child: Card(
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      provider
                                                          .visitList
                                                          ?.data
                                                          ?.myVisits?[index]
                                                          .title ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          provider
                                                              .visitList
                                                              ?.data
                                                              ?.myVisits?[index]
                                                              .date ??
                                                              "",
                                                          style: const TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Color(
                                                                  int.parse(provider
                                                                      .visitList
                                                                      ?.data
                                                                      ?.myVisits?[
                                                                  index]
                                                                      .statusColor ??
                                                                      "")),
                                                              style:
                                                              BorderStyle.solid,
                                                              width: 3.0,
                                                            ),
                                                            color: Color(int.parse(
                                                                provider
                                                                    .visitList
                                                                    ?.data
                                                                    ?.myVisits?[
                                                                index]
                                                                    .statusColor ??
                                                                    "")),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                          ),
                                                          child: DottedBorder(
                                                            color: Colors.white,
                                                            borderType:
                                                            BorderType.RRect,
                                                            radius: const Radius
                                                                .circular(5),
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 3),
                                                            strokeWidth: 1,
                                                            child: Text(
                                                              provider
                                                                  .visitList
                                                                  ?.data
                                                                  ?.myVisits?[
                                                              index]
                                                                  .status ??
                                                                  "",
                                                              style: const TextStyle(
                                                                  color:
                                                                  Colors.white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                color:
                                                AppColors.colorPrimary,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );

                            }),
                      )
                      :  Expanded(
                          child: Center(
                              child: Text(
                            tr("no_visit_found"),
                            style: const TextStyle(
                                color: Color(0x65555555),
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          )),
                        )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
