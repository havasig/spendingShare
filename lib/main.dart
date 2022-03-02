import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/widgets/calculator.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/my_appbar.dart';
import 'package:spending_share/ui/widgets/scroll_view.dart';
import 'package:spending_share/utils/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.loadAllTranslations();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // TODO 360 es 690 jo szamok?
      minTextAdapt: true, // TODO ez mi
      splitScreenMode: true, // TODO ez mi
      builder: () => GetMaterialApp(
        title: 'Speding Share',
        theme: ThemeData(
            fontFamily: 'Nunito',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: ColorConstants.backgroundBlack,
            scrollbarTheme: ScrollbarThemeData(
                isAlwaysShown: true,
                thickness: MaterialStateProperty.all(10),
                thumbColor: MaterialStateProperty.all(ColorConstants.defaultOrange),
                radius: const Radius.circular(10))),
        themeMode: ThemeMode.dark,
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        translations: LocalizationService(),
        builder: (context, child) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: const LoginPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: widget.title,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Input Field Page'),
              onPressed: () {
                Get.to(() => const InputFieldPage());
              },
            ),
            ElevatedButton(
              child: const Text('Scroll View Page'),
              onPressed: () {
                Get.to(() => ScrollViewPage());
              },
            ),
            ElevatedButton(
              child: const Text('Calculator Page'),
              onPressed: () {
                Get.to(() => CalculatorPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
