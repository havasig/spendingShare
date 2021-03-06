import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/auth/authentication.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/utils/config/environment.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/localization_service.dart';

import 'firebase_options.dart';
import 'models/data/create_transaction_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.loadAllTranslations();
  await initializeEnvironment();
  await getCurrencies();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instanceFor(app: app);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationState()),
        ChangeNotifierProvider(create: (context) => CreateTransactionChangeNotifier()),
        ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
        ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
        Provider(
            create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                )),
        Provider(create: (context) => CreateTransactionData()),
      ],
      child: MyApp(firestore: firestore),
    ),
  );
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

Future<void> initializeEnvironment() async {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  Environment().initConfig(environment);
}

Future<void> getCurrencies() async {
  try {
    String uri = '${Environment().config.currencyConverterbaseUrl}/currency/list?api_key=${Environment().config.currencyConverterApiKey}';
    var response = await http.get(Uri.parse(uri));
    Map<String, dynamic> curMap = json.decode(response.body);
    globals.currencies.clear();
    globals.currencies.addAll(curMap['currencies']);
  } on Exception catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // TODO 360 es 690 jo szamok?
      minTextAdapt: true, // TODO ez mi
      splitScreenMode: true, // TODO ez mi
      builder: () => GetMaterialApp(
        title: 'Speding Share',
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: ColorConstants.backgroundBlack,
            modalBackgroundColor: ColorConstants.backgroundBlack,
          ),
          fontFamily: 'Nunito',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ColorConstants.backgroundBlack,
          scrollbarTheme: ScrollbarThemeData(
            isAlwaysShown: true,
            thickness: MaterialStateProperty.all(6),
            radius: const Radius.circular(4),
          ),
        ),
        themeMode: ThemeMode.dark,
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        translations: LocalizationService(),
        builder: (context, child) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: MyHomePage(firestore: firestore),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
            loginState: appState.loginState,
            firestore: widget.firestore,
          ),
        ),
      ),
    );
  }
}
