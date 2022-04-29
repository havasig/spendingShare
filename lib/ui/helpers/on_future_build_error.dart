import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/utils/loading_indicator.dart';

class OnFutureBuildError extends StatelessWidget {
  const OnFutureBuildError(this.snapshot, {Key? key}) : super(key: key);
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Text('something_went_wrong'.tr);
    }

    if (snapshot.hasData && !snapshot.data?.exists) {
      return Text('document_does_not_exists'.tr);
    }

    return const LoadingIndicator();
  }
}
