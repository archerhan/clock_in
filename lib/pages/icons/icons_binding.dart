import 'package:clock_in/pages/icons/icons_controller.dart';
import 'package:get/get.dart';

class IconsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IconsController>(() => IconsController());
  }
  
}