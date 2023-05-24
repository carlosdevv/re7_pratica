import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/controllers/profile_controller.dart';
import 'package:re7_pratica/models/social_network_props.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';
import 'package:url_launcher/link.dart';

class TableSocialNetwork extends StatefulWidget {
  const TableSocialNetwork({Key? key}) : super(key: key);

  @override
  State<TableSocialNetwork> createState() => _TableSocialNetworkState();
}

class _TableSocialNetworkState extends State<TableSocialNetwork> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.wsz),
      child: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return ListView.builder(
              itemCount: controller.listSocialNetwork.length,
              itemBuilder: (context, index) {
                final consultor = controller.listSocialNetwork[index];
                if (controller.onLoadingListSocialNetwork.value) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20.wsz),
                    child: Transform.scale(
                      scale: 0.85,
                      child: showLoading(AppColors.primary, 3),
                    ),
                  );
                } else {
                  return _itemList(consultor);
                }
              });
        },
      ),
    );
  }

  Container _itemList(SocialNetworkProps consultor) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.wsz, 20.wsz, 16.wsz, 20.wsz),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: AppColors.primary,
          width: 1.wsz,
        ),
      )),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              consultor.nmConsultor.capitalize!,
              style: TextStyle(
                  color: AppColors.text100,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.wsz),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                consultor.instagram != null
                    ? Link(
                        uri: Uri.parse(consultor.instagram!),
                        builder: (context, followLink) => InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: followLink,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.wsz),
                            padding: EdgeInsets.all(8.wsz),
                            decoration: const BoxDecoration(
                              color: AppColors.containerInput,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppImages.instagramIcon,
                              width: 26.wsz,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                consultor.facebook != null
                    ? Link(
                        uri: Uri.parse(consultor.facebook!),
                        builder: (context, followLink) => InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: followLink,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.wsz),
                            padding: EdgeInsets.all(8.wsz),
                            decoration: const BoxDecoration(
                              color: AppColors.containerInput,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppImages.facebookIcon,
                              width: 26.wsz,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                consultor.twitter != null
                    ? Link(
                        uri: Uri.parse(consultor.twitter!),
                        builder: (context, followLink) => InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: followLink,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.wsz),
                            padding: EdgeInsets.all(8.wsz),
                            decoration: const BoxDecoration(
                              color: AppColors.containerInput,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppImages.twitterIcon,
                              width: 26.wsz,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                consultor.youtube != null
                    ? Link(
                        uri: Uri.parse(consultor.youtube!),
                        builder: (context, followLink) => InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: followLink,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.wsz),
                            padding: EdgeInsets.all(8.wsz),
                            decoration: const BoxDecoration(
                              color: AppColors.containerInput,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppImages.youtubeIcon,
                              width: 26.wsz,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
