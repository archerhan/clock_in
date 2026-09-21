// ignore_for_file: invalid_use_of_protected_member

import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/utils/number_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class CustomLineChart extends StatelessWidget {
  final List<Tuple2> weekCheckData;
  const CustomLineChart(this.weekCheckData, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        child: LineChart(
          mainData(),
        ).paddingSymmetric(horizontal: 20.w),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: AppColors.bgColor,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final flSpot = touchedSpot;
              if (flSpot.x == 0 || flSpot.x == weekCheckData.length - 1) {
                return null;
              }
              return LineTooltipItem(
                "${flSpot.y.toInt()}次",
                const TextStyle(
                  color: AppColors.mainTitle333,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
        touchCallback: (event, touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.dividerEEE,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.dividerEEE,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: const Border(
            left: BorderSide(width: 1, color: AppColors.dividerEEE),
            bottom: BorderSide(width: 1, color: AppColors.dividerEEE)),
        show: true,
      ),
      minX: weekCheckData.isNotEmpty
          ? weekCheckData
                  .map((e) => e.item1.toDouble())
                  .reduce((a, b) => a < b ? a : b) ??
              0
          : 0,
      maxX: weekCheckData.isNotEmpty
          ? weekCheckData
                  .map((e) => e.item1.toDouble())
                  .reduce((a, b) => a > b ? a : b) ??
              0
          : 0,
      minY: 0,
      maxY: weekCheckData.isNotEmpty
          ? weekCheckData
                  .map((e) => e.item2.toDouble())
                  .reduce((a, b) => a > b ? a : b) ??
              0
          : 0,
      lineBarsData: [
        LineChartBarData(
          spots: weekCheckData
              .map((e) => FlSpot(e.item1.toDouble(), e.item2.toDouble()))
              .toList(),
          preventCurveOverShooting: true,
          isCurved: true,
          gradient: const LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.purple,
              ].map((color) => color.withValues(alpha: 0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10.sp,
        color: AppColors.subtitle666);
    final numberData = NumberUtil.getNumbers(meta.max.toInt());
    if (numberData.isNotEmpty) {
      numberData[0] = 1;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
          numberData.contains(value.toInt()) ? "第${value.toInt()}周" : "",
          style: style,
          textAlign: TextAlign.center),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
        color: AppColors.subtitle666);
    final numberData = NumberUtil.getNumbers(meta.max.toInt());
    return Text(
      numberData.contains(value.toInt()) ? "${value.toInt()}" : "",
      style: style,
      textAlign: TextAlign.center,
    );
  }
}
