import 'package:flutter/material.dart';
import 'package:zaindev_application/core/constants/app_colors.dart';
import 'package:zaindev_application/presentation/extensions/sizedbox.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              FlutterLogo(size: 40),
              8.w,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi Ali Tarek"),
                  4.h,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.location_searching, size: 18,),
                      8.w,
                      Text("Saudi Arabia")
                    ],
                  )
                ],
              )
            ],
          ),
        ),

        Icon(Icons.notifications_outlined, color: AppColors.black, size: 30,)
      ],
    );
  }
}