import 'package:bot_toast/bot_toast.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:clock_in/i18n/app_translation.dart';
import 'package:clock_in/pages/root/root_binding.dart';
import 'package:clock_in/pages/root/root_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await _initServices();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('zh', null).then(
    (_) => runApp(
      const MyApp(),
    ),
  );

  _otherConfigs();
}

/// service里面做App启动前的初始化,比如初始化存储,初始化主题数据,
/// 初始化多语言(动态下发多语言),初始化设置等
/// 里面的执行顺序不能变, 否则会出错
Future _initServices() async {
  // await Get.putAsync(() async => await GetStorage.init(), permanent: true);
  // await Get.putAsync(() async => IsarService.instance);
}

void _otherConfigs() async {
  await DBManager.instance.database;
  await DBManager.instance.backupDatabase;
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    // systemNavigationBarColor: Colors.black,
    // systemNavigationBarDividerColor: Colors.transparent,
    // systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(Get.context!).requestFocus(FocusNode());
        },
        child: GetMaterialApp(
          enableLog: false,
          translationsKeys: AppTranslation.translations,
          locale: Get.locale,
          defaultTransition: Transition.cupertino,
          popGesture: Get.isPopGestureEnable,
          fallbackLocale: const Locale('zh', 'CN'),
          initialBinding: RootBinding(),
          home: const RootPage(),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: false,
              // 全局去掉点击的背景高亮颜色
              highlightColor: Colors.transparent,
              // 全局去掉水波纹效果
              splashColor: Colors.transparent),
          builder: (context, widget) {
            widget = MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
            widget = botToastBuilder(context, widget);
            return widget;
          },
        ),
      ),
    );
  }
}
