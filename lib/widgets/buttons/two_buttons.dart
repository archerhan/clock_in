import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/widgets/buttons/ok_button.dart';
import 'package:flutter/widgets.dart';

class TwoButtons extends StatelessWidget {
  final String title1;
  final String title2;
  final Function()? onPressed1;
  final Function()? onPressed2;
  const TwoButtons(
      {required this.title1,
      required this.title2,
      this.onPressed1,
      this.onPressed2,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onPressed1,
            child: OKButton(
              title: title1,
              onPressed: onPressed1,
              backgroundColor: AppColors.warningRed,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onPressed2,
            child: OKButton(
              title: title2,
              onPressed: onPressed2,
              backgroundColor: AppColors.primaryBlue,
            )
          ),
        ),
      ],
    );
  }
}
