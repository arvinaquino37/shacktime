import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:hrm_app/utils/res.dart';

class CurrentMonth extends StatelessWidget {
  final HomeProvider? provider;

  const CurrentMonth({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: const Text(
            'current_month',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: 0.5),
          ).tr(),
        ),
        const SizedBox(height: 8),
        provider?.currentMothList != null
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    provider?.currentMothList?.length ?? 0,
                    (index) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: SizedBox(
                            width: 125,
                            child: Column(
                              children: [
                                Image.network(
                                  '${provider?.currentMothList?[index].image}',
                                  height: 25,
                                  color: AppColors.colorPrimary,
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    Text(
                                      '${provider?.currentMothList?[index].number ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          letterSpacing: 0.5),
                                    ),
                                    const Text(
                                      'days',
                                      style: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 4,
                                          letterSpacing: 0.5),
                                    ).tr(),
                                  ],
                                ),
                                Text(
                                  provider?.currentMothList?[index].title ?? '',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      letterSpacing: 0.5),
                                ),
                                const SizedBox(
                                  height: 6,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(height: 100),
        const SizedBox(height: 80)
      ],
    );
  }
}
