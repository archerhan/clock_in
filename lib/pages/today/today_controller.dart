import 'package:get/get.dart';

class TodayController extends GetxController {

  var today = DateTime.now();
  // 往前推三个月的第一天
  var calendarFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  // 获取当月最后一天
  var calendarLastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

}
