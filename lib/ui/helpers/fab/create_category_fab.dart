import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/group_data.dart';
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

class CreateCategoryFab extends StatelessWidget {
  CreateCategoryFab({Key? key, required this.firestore, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_CategoryNameFormState');

  @override
  Widget build(BuildContext context) {
    var selectIconChangeNotifier = Provider.of<SelectIconChangeNotifier>(context, listen: false);
    selectIconChangeNotifier.icon = groupData.icon;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        key: const Key('create_category'),
        tooltip: 'create_category'.tr,
        backgroundColor: groupData.color,
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
                  Text('add_new_category_name'.tr, style: TextStyleConstants.body_1),
                  Form(
                    key: _formKey,
                    child: InputField(
                      validator: TextValidator.validateIsNotEmpty,
                      labelColor: groupData.color,
                      focusColor: groupData.color,
                      key: const Key('category_name_input'),
                      focusNode: _focusNode,
                      textEditingController: _textEditingController,
                      prefixIcon: Icon(Icons.mail, color: groupData.color),
                      labelText: 'category'.tr,
                      hintText: 'category'.tr,
                    ),
                  ),
                  Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                  SelectCategoryIcon(defaultIcon: groupData.icon!, color: groupData.color),
                  Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                  Button(
                    buttonColor: groupData.color,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(Tuple2(_textEditingController.text, selectIconChangeNotifier.icon));
                      }
                    },
                    text: 'create'.tr,
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
            var categoryReference = await firestore.collection('categories').add({
              'name': value.item1,
              'icon': globals.icons.entries.firstWhereOrNull((element) => element.value == value.item2)?.key ?? 'default',
              'transactions': [],
            });

            var group = await firestore.collection('groups').doc(groupData.groupId).get();
            var newCategoryReferenceList = group.data()!['categories'];
            newCategoryReferenceList.add(categoryReference);

            await firestore
                .collection('groups')
                .doc(groupData.groupId)
                .set({'categories': newCategoryReferenceList}, SetOptions(merge: true));
          }
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
