import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:shimmer/shimmer.dart';

class GreetingsSection extends StatelessWidget {
  final HomeProvider? provider;

  const GreetingsSection({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              provider?.timeWish != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        provider?.timeWish?.wish ?? "",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFE8E8E8),
                            highlightColor: Colors.white,
                            child: Container(
                                height: 14,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(
                                      10), // radius of 10// green as background color
                                )),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: provider?.timeWish != null
                    ? Text(
                        '${provider?.userName}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Colors.white),
                      )
                    : Shimmer.fromColors(
                        baseColor: const Color(0xFFE8E8E8),
                        highlightColor: Colors.white,
                        child: Container(
                            height: 14,
                            width: 160,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(
                                  10), // radius of 10// green as background color
                            )),
                      ),
              ),
              provider?.timeWish != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        provider?.timeWish?.subTitle ?? '',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFE8E8E8),
                            highlightColor: Colors.white,
                            child: Container(
                                height: 12,
                                width: 260,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(
                                      10), // radius of 10// green as background color
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFE8E8E8),
                            highlightColor: Colors.white,
                            child: Container(
                                height: 12,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(
                                      10), // radius of 10// green as background color
                                )),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        SvgPicture.network(
          provider?.timeWish?.image ?? "",
          semanticsLabel: 'A shark?!',
          height: 60,
          width: 60,
          placeholderBuilder: (BuildContext context) => const SizedBox(),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
