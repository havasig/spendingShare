import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_category_icon.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';
import 'package:tuple/tuple.dart';

class CreateCategoryDataFab extends StatelessWidget {
  const CreateCategoryDataFab({Key? key, required this.firestore, required this.color, required this.icon, required this.userId})
      : super(key: key);

  final FirebaseFirestore firestore;
  final MaterialColor color;
  final IconData icon;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(debugLabel: '_CategoryCreateFormState');
    final FocusNode _focusNode = FocusNode();
    final TextEditingController _textEditingController = TextEditingController();
    var selectIconChangeNotifier = Provider.of<SelectIconChangeNotifier>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        key: const Key('create_transaction'),
        tooltip: 'create_transaction',
        backgroundColor: color,
        splashColor: ColorConstants.lightGray,
        onPressed: () => showBarModalBottomSheet(
          expand: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.all(h(16)),
              child: Column(
                children: [
                  Text('create_category'.tr, style: TextStyleConstants.h_5),
                  Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                  Form(
                    key: _formKey,
                    child: InputField(
                      validator: TextValidator.validateIsNotEmpty,
                      labelColor: color,
                      focusColor: color,
                      key: const Key('category_create_input'),
                      focusNode: _focusNode,
                      textEditingController: _textEditingController,
                      prefixIcon: Icon(Icons.mail, color: color),
                      labelText: 'new_name'.tr,
                      hintText: 'new_name'.tr,
                    ),
                  ),
                  Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                  SelectCategoryIcon(defaultIcon: icon, color: color),
                  Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                  Button(
                    buttonColor: color,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(Tuple2(_textEditingController.text, selectIconChangeNotifier.icon));
                      }
                    },
                    text: 'save'.tr,
                    textStyle: TextStyleConstants.sub_1_medium.copyWith(color: ColorConstants.textBlack),
                  ),
                  Button(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'close'.tr,
                    textStyle: TextStyleConstants.sub_1,
                    buttonColor: Colors.transparent,
                    borderSide: BorderSide(
                      color: ColorConstants.white.withOpacity(0.5),
                    ),
                    textColor: ColorConstants.white.withOpacity(0.8),
                  )
                ],
              ),
            );
          },
        ).then((value) async {
          if (value != null) {
            value as Tuple2<String, IconData?>;
            String? iconString = globals.icons.entries.firstWhereOrNull((element) => element.value == value.item2)?.key;
            await firestore.collection('users').doc(userId).collection('categoryData').add({
              'name': value.item1,
              'icon': iconString ?? 'default',
            });
          }
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
