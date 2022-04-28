import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class CreateTransactionDropdown extends StatefulWidget {
  const CreateTransactionDropdown(
      {Key? key, this.defaultValue, required this.options, required this.title, required this.color, required this.onSelect})
      : super(key: key);

  final String? defaultValue;
  final String title;
  final MaterialColor color;
  final Map<String, dynamic> options;
  final Function(dynamic) onSelect;

  @override
  State<CreateTransactionDropdown> createState() => _CreateTransactionDropdownState();
}

class _CreateTransactionDropdownState extends State<CreateTransactionDropdown> {
  Map<String, dynamic> dropDownItems = {};
  String _dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropDownItems.addAll(widget.options);
    _dropdownValue = widget.defaultValue ?? dropDownItems.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          Container(
            padding: EdgeInsets.symmetric(horizontal: h(6)),
            decoration: BoxDecoration(
              border: Border.all(color: widget.color),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: DropdownButton<String>(
              value: _dropdownValue,
              dropdownColor: ColorConstants.darkGray,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              elevation: 6,
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                color: widget.color,
              ),
              underline: Container(height: 0),
              onChanged: (String? newValue) {
                setState(() {
                  widget.onSelect(widget.options.entries.where((element) => element.key == newValue).first.value);
                  _dropdownValue = newValue!;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return dropDownItems.keys.map<Widget>((key) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(key),
                  );
                }).toList();
              },
              items: dropDownItems.keys.map<DropdownMenuItem<String>>((key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    key,
                    style: _dropdownValue == key ? TextStyle(color: widget.color) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
