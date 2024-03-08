import 'package:clock_in/widgets/date_picker/date_picker_controller.dart';
import 'package:clock_in/widgets/date_picker/date_picker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 日期选择弹框
Future<int?> showCustomDateTimeDialog(
    {DatePickerShowType? showType, Function(String)? onOKTap}) async {
  var logic = Get.find<DatePickerController>();
  return showModalBottomSheet<int>(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: Get.context!,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        height: MediaQuery.of(context).size.height / 3.0,
        child: Column(children: [
          SizedBox(
            height: 50.h,
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    var date = "";
                    if (showType == DatePickerShowType.ymd) {
                      date =
                          '${logic.selectYear}-${logic.selectMonth}-${logic.selectDay}';
                    } else {
                      date = '${logic.selectYear}-${logic.selectMonth}';
                    }
                    if (onOKTap != null) {
                      onOKTap(date);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '确定',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0),
          Expanded(
              child: DatePickerView(
            showType: showType ?? DatePickerShowType.ymd,
          )),
        ]),
      );
    },
  );
}
