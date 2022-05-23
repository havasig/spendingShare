import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/category_data.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_category_icon.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';
import 'package:tuple/tuple.dart';

import 'create_category_data_fab.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedColorIndex = 0;
  int selectedIconIndex = 0;
  late SpendingShareUser currentUser;

  @override
  void initState() {
    currentUser = Provider.of(context, listen: false);
    globals.colors.values.toList().asMap().forEach((index, value) => {if (value == currentUser.color) selectedColorIndex = index});
    globals.icons.values.toList().asMap().forEach((index, value) => {if (value == currentUser.icon) selectedIconIndex = index});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SpendingShareUser user = Provider.of(context);
    String _currencyDropdownValue = user.currency;
    String _languageDropdownValue = user.language;

    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'settings'.tr, hasBack: false),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: h(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('default_currency'.tr),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: h(6)),
                      decoration: BoxDecoration(
                        border: Border.all(color: currentUser.color),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: DropdownButton<String>(
                        key: const Key('default_currency_dropdown'),
                        value: _currencyDropdownValue,
                        dropdownColor: ColorConstants.darkGray,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        elevation: 6,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: currentUser.color,
                        ),
                        underline: Container(height: 0),
                        onChanged: (String? newValue) {
                          setState(() {
                            _currencyDropdownValue = newValue!;
                            user.currency = newValue;
                            widget.firestore.collection('users').doc(user.databaseId).set({'currency': newValue}, SetOptions(merge: true));
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return globals.currencies.keys.map<Widget>((key) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(key),
                            );
                          }).toList();
                        },
                        items: globals.currencies.keys.map<DropdownMenuItem<String>>((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: _currencyDropdownValue == key ? TextStyle(color: currentUser.color) : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: h(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('language'.tr),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: h(6)),
                      decoration: BoxDecoration(
                        border: Border.all(color: currentUser.color),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: DropdownButton<String>(
                        key: const Key('default_language_dropdown'),
                        value: _languageDropdownValue,
                        dropdownColor: ColorConstants.darkGray,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        elevation: 6,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: currentUser.color,
                        ),
                        underline: Container(height: 0),
                        onChanged: (String? newValue) {
                          setState(() {
                            _languageDropdownValue = newValue!;
                            user.language = newValue;
                            widget.firestore.collection('users').doc(user.databaseId).set({'language': newValue}, SetOptions(merge: true));
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return globals.languages.map<Widget>((key) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(key),
                            );
                          }).toList();
                        },
                        items: globals.languages.map<DropdownMenuItem<String>>((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: _languageDropdownValue == key ? TextStyle(color: currentUser.color) : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
              Column(
                key: const Key('default_color_selector'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [Text('default_color'.tr)],
                  ),
                  SizedBox(height: h(6)),
                  SizedBox(
                    height: h(38),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: globals.colors.length,
                      itemBuilder: (context, index) {
                        MaterialColor value = globals.colors.values.elementAt(index);

                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Material(
                              type: MaterialType.transparency,
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: value[globals.circleShade] ?? Colors.orange[globals.circleShade],
                                    shape: BoxShape.circle,
                                    border: selectedColorIndex == index
                                        ? Border.all(color: value[globals.iconShade] ?? Colors.orange[globals.iconShade]!, width: h(3))
                                        : Border.all(color: value[globals.circleShade] ?? Colors.orange[globals.iconShade]!, width: h(3))),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(1000),
                                  onTap: () {
                                    setState(() {
                                      selectedColorIndex = index;
                                      currentUser.color = value;
                                      user.color = value;
                                      widget.firestore.collection('users').doc(user.databaseId).set(
                                          {'color': globals.colors.entries.firstWhere((element) => element.value == value).key},
                                          SetOptions(merge: true));
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(h(12)),
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
              Column(
                key: const Key('default_icon_selector'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [Text('default_icon'.tr)],
                  ),
                  SizedBox(height: h(6)),
                  SizedBox(
                    height: h(150),
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: h(8),
                          mainAxisSpacing: h(8),
                        ),
                        itemCount: globals.icons.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIconIndex = index;
                                  user.icon = globals.icons.values.toList()[index];
                                  widget.firestore.collection('users').doc(user.databaseId).set({
                                    'icon': globals.icons.entries
                                        .firstWhere((element) => element.value == globals.icons.values.toList()[index])
                                        .key
                                  }, SetOptions(merge: true));
                                });
                              },
                              child: Icon(
                                globals.icons.values.toList()[index],
                                size: h(34),
                                color: selectedIconIndex == index ? currentUser.color[globals.circleShade] : null,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
              StreamBuilder(
                  stream: widget.firestore.collection('users').doc(user.databaseId).collection('categoryData').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> categoryDataListSnapshot) {
                    if (categoryDataListSnapshot.hasData) {
                      return Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 10,
                          spacing: 15,
                          children: categoryDataListSnapshot.data!.docs.map((cd) {
                            var categoryData = CategoryData.fromDocument(cd);
                            List<CategoryData> categoryListWithoutCurrent = [];
                            categoryListWithoutCurrent.addAll(user.categoryData);
                            categoryListWithoutCurrent.removeWhere((value) => value == categoryData);
                            final FocusNode _focusNode = FocusNode();
                            final TextEditingController _textEditingController = TextEditingController();
                            final _formKey = GlobalKey<FormState>(debugLabel: '_CategoryRenameFormState');
                            var selectIconChangeNotifier = Provider.of<SelectIconChangeNotifier>(context, listen: false);
                            selectIconChangeNotifier.icon = categoryData.icon;
                            _textEditingController.text = categoryData.name;
                            bool deleted = false;
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
                                                    Text('set_new_category_name'.tr + categoryData.name, style: TextStyleConstants.body_1),
                                                    Form(
                                                      key: _formKey,
                                                      child: InputField(
                                                        validator: TextValidator.validateIsNotEmpty,
                                                        labelColor: currentUser.color,
                                                        focusColor: currentUser.color,
                                                        key: const Key('category_rename_input'),
                                                        focusNode: _focusNode,
                                                        textEditingController: _textEditingController,
                                                        prefixIcon: Icon(Icons.mail, color: currentUser.color),
                                                        labelText: 'new_name'.tr,
                                                        hintText: 'new_name'.tr,
                                                      ),
                                                    ),
                                                    Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                                                    SelectCategoryIcon(defaultIcon: categoryData.icon, color: currentUser.color),
                                                    Divider(thickness: 1, color: ColorConstants.white.withOpacity(0.2)),
                                                    Button(
                                                      buttonColor: currentUser.color,
                                                      onPressed: () {
                                                        if (_formKey.currentState!.validate()) {
                                                          Navigator.of(context)
                                                              .pop(Tuple2(_textEditingController.text, selectIconChangeNotifier.icon));
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
                                              String? iconString =
                                                  globals.icons.entries.firstWhereOrNull((element) => element.value == value.item2)?.key;
                                              await widget.firestore
                                                  .collection('users')
                                                  .doc(user.databaseId)
                                                  .collection('categoryData')
                                                  .doc(categoryData.databaseId)
                                                  .set({
                                                'name': value.item1,
                                                'icon': iconString ?? 'default',
                                              }, SetOptions(merge: true));
                                            }
                                          }),
                                          color: currentUser.color,
                                          width: 20,
                                          name: categoryData.name,
                                          icon: categoryData.icon,
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
                                                          color: currentUser.color,
                                                        );
                                                      });
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AreYouSureDialog(
                                                          title: 'are_you_sure'.tr,
                                                          message: 'if_you_delete_category_data'.tr,
                                                          okText: 'delete'.tr,
                                                          cancelText: 'cancel'.tr,
                                                          color: currentUser.color,
                                                        );
                                                      }).then((value) async {
                                                    if (value) {
                                                      deleted = true;
                                                      await widget.firestore
                                                          .collection('users')
                                                          .doc(user.databaseId)
                                                          .collection('categoryData')
                                                          .doc(categoryData.databaseId)
                                                          .delete();
                                                      user.categoryData.remove(categoryData);
                                                      setState(() {});
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
            ],
          ),
        ),
      ),
      floatingActionButton: CreateCategoryDataFab(
        key: const Key('create_category_data_fab'),
        firestore: widget.firestore,
        color: currentUser.color,
        icon: currentUser.icon,
        userId: currentUser.databaseId,
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 2,
        firestore: widget.firestore,
        color: currentUser.color,
      ),
    );
  }
}
