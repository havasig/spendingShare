import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/auth/authentication.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class _Wrapper extends StatelessWidget {
  final Widget child;

  const _Wrapper(this.child);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(const BoxConstraints(), context: context);
    return child;
  }
}

Widget testableWidget({required Widget child}) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MultiProvider(
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
      child: GetMaterialApp(
        home: Scaffold(body: _Wrapper(child)),
      ),
    ),
  );
}
