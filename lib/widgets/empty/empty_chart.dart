import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyChart extends StatelessWidget {
  final IconData? iconData;
  final String? text;
  const EmptyChart({this.iconData, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 80,
              color: AppColors.dividerEEE,
            ),
            const SizedBox(height: 20),
            Text(
              text ?? "",
              style: const TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
