import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

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
    child: GetMaterialApp(
      home: Scaffold(body: _Wrapper(child)),
    ),
  );
}
