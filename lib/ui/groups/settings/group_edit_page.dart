import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/create/select_color.dart';
import 'package:spending_share/ui/groups/create/select_currency.dart';
import 'package:spending_share/ui/groups/create/select_icon.dart';
import 'package:spending_share/ui/groups/details/group_details_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

class GroupEditPage extends StatefulWidget {
  const GroupEditPage({Key? key, required this.firestore, required this.groupId}) : super(key: key);

  final FirebaseFirestore firestore;
  final String groupId;

  @override
  State<GroupEditPage> createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  final FocusNode _groupNameFocusNode = FocusNode();
  final TextEditingController _groupNameTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_CreateGroupFormState');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SpendingShareAppBar(titleText: 'create_group'.tr),
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: FutureBuilder<DocumentSnapshot>(
            future: widget.firestore.collection('groups').doc(widget.groupId).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Group group = Group.fromDocument(snapshot.data!);
                CreateGroupChangeNotifier _createGroupChangeNotifier = CreateGroupChangeNotifier(
                  group.adminId,
                  group.currency,
                  group.color,
                  globals.colors[group.color],
                  group.icon,
                  globals.icons[group.icon],
                );
                return ChangeNotifierProvider(
                  create: (context) => _createGroupChangeNotifier,
                  child: Column(
                    children: [
                      SizedBox(height: h(6)),
                      Form(
                        key: _formKey,
                        child: InputField(
                          validator: TextValidator.validateGroupNameText,
                          key: const Key('group_name_input'),
                          focusNode: _groupNameFocusNode,
                          textEditingController: _groupNameTextEditingController,
                          labelText: 'name'.tr,
                          hintText: 'group_name'.tr,
                          prefixIcon: const Icon(
                            Icons.group,
                            color: ColorConstants.defaultOrange,
                          ),
                        ),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => _createGroupChangeNotifier as CreateChangeNotifier,
                        child: SelectCurrency(currency: group.currency, color: group.color),
                      ),
                      SelectColor(defaultColor: group.color),
                      SelectIcon(defaultIcon: group.icon),
                      const Spacer(),
                      Button(
                        onPressed: () async {
                          _createGroupChangeNotifier.setName(_groupNameTextEditingController.text);
                          if (_formKey.currentState!.validate() && _createGroupChangeNotifier.validateFirstPage()) {
                            try {
                              List<DocumentReference> memberReferences = [];
                              for (var member in _createGroupChangeNotifier.members) {
                                memberReferences.add(await widget.firestore.collection('members').add({
                                  'name': member,
                                  'userFirebaseId': _createGroupChangeNotifier.adminId,
                                }));
                              }
/*
                              // TODO update not overwrite
                              List<DocumentReference> categoryReferences = [];
                              categoryReferences.add(await widget.firestore.collection('categories').add({
                                'name': 'other'.tr,
                                'transactions': [],
                              }));

                              DocumentReference groupReference = await widget.firestore.collection('groups').add({
                                'adminId': _createGroupChangeNotifier.adminId,
                                'name': _createGroupChangeNotifier.name,
                                'color': _createGroupChangeNotifier.colorName,
                                'currency': _createGroupChangeNotifier.currency,
                                'icon': _createGroupChangeNotifier.iconName,
                                'members': memberReferences,
                                'categories': categoryReferences,
                                'transactions': [],
                                'debts': [],
                              });

                              SpendingShareUser user = Provider.of(context, listen: false);

                              DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                                  await widget.firestore.collection('users').doc(user.databaseId).get();

                              List<dynamic> newGroupReferenceList = userSnapshot.data()!['groups'];
                              newGroupReferenceList.add(groupReference);

                              await widget.firestore
                                  .collection('users')
                                  .doc(user.databaseId)
                                  .set({'groups': newGroupReferenceList}, SetOptions(merge: true));
*/
                              Get.offAll(() => GroupDetailsPage(firestore: widget.firestore, hasBack: false, groupId: widget.groupId));
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorDialog(
                                    title: 'group_edit_failed'.tr,
                                    message: '${(e as dynamic).message}'.tr,
                                  );
                                },
                              );
                            }
                          }
                        },
                        text: 'save_changes'.tr,
                        textColor: globals.colors[_createGroupChangeNotifier.colorName]!,
                        buttonColor: globals.colors[_createGroupChangeNotifier.colorName]!.withOpacity(0.2),
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ],
                  ),
                );
              }
              return OnFutureBuildError(snapshot);
            },
          ),
        ),
        bottomNavigationBar: SpendingShareBottomNavigationBar(
          selectedIndex: 1,
          firestore: widget.firestore,
        ),
      ),
    );
  }
}
