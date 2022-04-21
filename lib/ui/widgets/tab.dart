import 'package:flutter/cupertino.dart';

class SpendingShareTab {
  final String header;
  final Function(BuildContext)? onSelect;
  final Widget content;

  SpendingShareTab(this.header, this.content, {this.onSelect});
}
