import 'package:flutter/cupertino.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(h(8)),
          child: const CupertinoActivityIndicator(),
        ));
  }
}
