import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/helpers/fab/create_category_fab.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_category_icon.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/ui/widgets/dialogs/select_new_category_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';
import 'package:tuple/tuple.dart';

class GroupCategoriesPage extends StatefulWidget {
  const GroupCategoriesPage({Key? key, required this.firestore, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;

  @override
  State<GroupCategoriesPage> createState() => _GroupCategoriesPageState();
}

class _GroupCategoriesPageState extends State<GroupCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'categories'.tr),
      body: Padding(
        padding: EdgeInsets.all(h(8)),
        child: StreamBuilder<List<DocumentSnapshot>>(
            stream: widget.firestore.collection('groups').doc(widget.groupData.groupId).snapshots().switchMap((group) {
              return CombineLatestStream.list(
                  group.data()!['categories'].map<Stream<DocumentSnapshot>>((category) => (category as DocumentReference).snapshots()));
            }),
            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> categoryListSnapshot) {
              if (categoryListSnapshot.hasData) {
                Map<String, dynamic> options = {};
                for (var category in categoryListSnapshot.data!) {
                  category as DocumentSnapshot<Map<String, dynamic>>;
                  options.addAll({category.data()!['name']: category.reference});
                }

                return Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 10,
                    spacing: 15,
                    children: categoryListSnapshot.data!.map((c) {
                      var category = Category.fromDocument(c);
                      bool deleted = false;
                      Map<String, dynamic> categoryListWithoutCurrent = Map.from(options)
                        ..removeWhere((key, value) => value == c.reference);

                      final FocusNode _focusNode = FocusNode();
                      final TextEditingController _textEditingController = TextEditingController();
                      final _formKey = GlobalKey<FormState>(debugLabel: '_CategoryRenameFormState');
                      var selectIconChangeNotifier = Provider.of<SelectIconChangeNotifier>(context, listen: false);
                      selectIconChangeNotifier.icon = category.icon;
                      _textEditingController.text = category.name;
                      return !deleted
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(h(6)),
                                  child: CircleIconButton(
                                    onTap: () => showBarModalBottomSheet(
                                      expand: true,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.all(h(16)),
                                          child: Column(
                                            children: [
                                              Text('rename_category'.tr, style: TextStyleConstants.h_5),
                                              Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                                              Text('set_new_category_name'.tr + category.name, style: TextStyleConstants.body_1),
                                              Form(
                                                key: _formKey,
                                                child: InputField(
                                                  validator: TextValidator.validateIsNotEmpty,
                                                  labelColor: widget.groupData.color,
                                                  focusColor: widget.groupData.color,
                                                  key: const Key('category_rename_input'),
                                                  focusNode: _focusNode,
                                                  textEditingController: _textEditingController,
                                                  prefixIcon: Icon(Icons.mail, color: widget.groupData.color),
                                                  labelText: 'new_name'.tr,
                                                  hintText: 'new_name'.tr,
                                                ),
                                              ),
                                              Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                                              SelectCategoryIcon(defaultIcon: category.icon!, color: widget.groupData.color),
                                              Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                                              Button(
                                                buttonColor: widget.groupData.color,
                                                onPressed: () {
                                                  if (_formKey.currentState!.validate()) {
                                                    Navigator.of(context)
                                                        .pop(Tuple2(_textEditingController.text, selectIconChangeNotifier.icon));
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
                                        widget.firestore.collection('categories').doc(category.databaseId).set({
                                          'name': value.item1,
                                          'icon': globals.icons.entries.firstWhereOrNull((element) => element.value == value.item2)?.key ??
                                              'default',
                                        }, SetOptions(merge: true));
                                      }
                                    }),
                                    color: widget.groupData.color,
                                    width: 20,
                                    name: category.name,
                                    icon: category.icon ?? widget.groupData.icon,
                                  ),
                                ),
                                Material(
                                    type: MaterialType.transparency,
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        color: ColorConstants.gray,
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(1000),
                                        onTap: () async {
                                          if (categoryListWithoutCurrent.isEmpty) {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ErrorDialog(
                                                    message: 'cannot_delete'.tr,
                                                    title: 'least_one_category'.tr,
                                                    color: widget.groupData.color,
                                                  );
                                                });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AreYouSureDialog(
                                                    message: 'if_you_delete_category'.tr,
                                                    title: 'are_you_sure'.tr,
                                                    okText: 'delete'.tr,
                                                    cancelText: 'cancel'.tr,
                                                    color: widget.groupData.color,
                                                  );
                                                }).then((value) async {
                                              if (value && category.transactions.isNotEmpty) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return SelectNewCategoryDialog(
                                                        options: categoryListWithoutCurrent,
                                                        color: widget.groupData.color,
                                                      );
                                                    }).then((newCategory) async {
                                                  if (newCategory != null) {
                                                    deleted = true;
                                                    deleteCategory(category.databaseId, newCategory);
                                                  }
                                                });
                                              } else if (value) {
                                                deleted = true;
                                                deleteCategory(category.databaseId, null);
                                              }
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(h(4)),
                                          child: Icon(
                                            Icons.close,
                                            size: h(14),
                                            color: ColorConstants.backgroundBlack,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          : const SizedBox.shrink();
                    }).toList());
              } else {
                return const SizedBox.shrink();
              }
            }),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        firestore: widget.firestore,
        selectedIndex: 1,
        color: widget.groupData.color,
      ),
      floatingActionButton: CreateCategoryFab(
        groupData: widget.groupData,
        firestore: widget.firestore,
      ),
    );
  }

  deleteCategory(databaseId, dynamic newCategory) async {
    setState(() {});
    if (newCategory != null) {
      var oldCategoryData = await widget.firestore.collection('categories').doc(databaseId).get();
      List<dynamic> oldTransactionList = oldCategoryData.data()!['transactions'];

      for (var transaction in oldTransactionList) {
        widget.firestore
            .collection('transactions')
            .doc((transaction as DocumentReference).id)
            .set({'category': newCategory}, SetOptions(merge: true));
      }

      var newCategoryData = await newCategory.get();
      List<dynamic> newTransactionList = newCategoryData.data()!['transactions'];

      newTransactionList.addAll(oldTransactionList);

      await widget.firestore
          .collection('categories')
          .doc((newCategory as DocumentReference).id)
          .set({'transactions': newTransactionList}, SetOptions(merge: true));
    }

    var group = await widget.firestore.collection('groups').doc(widget.groupData.groupId).get();
    List<dynamic> newCategoryReferenceList = group.data()!['categories'];
    newCategoryReferenceList.removeWhere((element) => element.id == databaseId);

    await widget.firestore
        .collection('groups')
        .doc(widget.groupData.groupId)
        .set({'categories': newCategoryReferenceList}, SetOptions(merge: true));

    widget.firestore.collection('categories').doc(databaseId).delete();
  }
}
