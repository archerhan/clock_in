import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/utils/custom_clipper.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:clock_in/widgets/line_chart/line_chart.dart';
import 'package:clock_in/widgets/pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/chart/chart_controller.dart';

class ChartPage extends GetView<ChartController> {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("统计"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _numberCardHorizontalView(),
            _title("全年打卡热度"),
            _heatMap(),
            _title("每周打卡统计"),
            const CustomLineChart(),
            _title("任务打卡分布"),
            const MyPieChart(),
            // _title("已获得的奖励"),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
            color: AppColors.mainTitle333,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _numberCardHorizontalView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 200.h,
      child: Row(
        children: [
          Expanded(
            child: FlipCard(
                frontWidget: Obx(() => _numberCard(
                      Icons.format_list_numbered,
                      Colors.amber,
                      "任务数",
                      controller.taskNum.value.toString(),
                      onTap: () {
                        controller.taskNumCon.flipcard();
                      },
                    )),
                backWidget: _numberCard(
                  Icons.format_list_numbered,
                  Colors.amber,
                  "任务数",
                  "3",
                  onTap: () => controller.taskNumCon.flipcard(),
                ),
                controller: controller.taskNumCon,
                rotateSide: RotateSide.left),
          ),
          Expanded(
            child: Obx(() => _numberCard(
                Icons.calendar_month_rounded,
                Colors.lightGreen,
                "最长打卡天数",
                controller.longestDay.value.toString())),
          ),
          Expanded(
            child: Obx(
              () => _numberCard(Icons.dynamic_feed, Colors.lightBlue, "单任务最长连续",
                  controller.longestContinue.value.toString()),
            ),
          )
        ],
      ),
    );
  }

  Widget _numberCard(IconData icon, Color color, String title, String number,
      {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      number,
                      style: TextStyle(
                          color: AppColors.subtitle666,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w900),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            color: AppColors.subtitle666, fontSize: 14.sp),
                      ),
                    ))
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: ClipPath(
                  clipper: MyTriangleClipper(),
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(6.r))),
                    child: Stack(
                      children: [
                        Positioned(
                            left: 10,
                            top: 10,
                            child: Icon(
                              icon,
                              size: 28.w,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _heatMap() {
    return HeatMap(
      datasets: {
        DateTime(2023, 12, 1): 3,
        DateTime(2024, 1, 7): 7,
        DateTime(2024, 1, 8): 10,
        DateTime(2024, 1, 9): 13,
        DateTime(2024, 1, 13): 6,
      },
      colorMode: ColorMode.opacity,
      defaultColor: AppColors.dividerEEE,
      showText: false,
      scrollable: true,
      colorTipHelper: const [Text("少"), Text("多")],
      colorsets: const {
        7: Colors.green,
      },
      weekStartsWith: 1,
      onClick: (value) {},
    ).paddingSymmetric(horizontal: 20.w, vertical: 10.h);
  }
}
