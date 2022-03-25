import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';

class CreateGroupFab extends StatelessWidget {
  const CreateGroupFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        key: const Key('create_group'),
        tooltip: 'create_group',
        backgroundColor: ColorConstants.defaultOrange,
        splashColor: ColorConstants.lightGray,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
