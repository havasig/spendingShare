import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/enums/split_by_type.dart';
import 'package:spending_share/models/enums/transaction_type.dart';

import 'currency_change_notifier.dart';

class CreateTransactionChangeNotifier extends CreateChangeNotifier {
  CreateTransactionChangeNotifier() : super(null);

  TransactionType _type = TransactionType.expense;
  DocumentReference? _category;
  DocumentReference? _member;
  DateTime _date = DateTime.now();
  String? _value;
  final List<DocumentReference> _to = [];
  SplitByType? _splitByType;
  String? _splitByWeights;
  String? _groupId;
  String? _color;
  String? _groupIcon;

  TransactionType get type => _type;

  DocumentReference? get category => _category;

  String? get groupId => _groupId;

  String? get color => _color;

  String? get groupIcon => _groupIcon;

  DocumentReference? get member => _member;

  DateTime get date => _date;

  String? get value => _value;

  List<DocumentReference> get to => _to;

  get splitByType => _splitByType;

  get splitByWeights => _splitByWeights;

  setGroupId(String groupId) {
    _groupId = groupId;
  }

  setColor(String color) {
    _color = color;
  }

  setGroupIcon(String groupIcon) {
    _groupIcon = groupIcon;
  }

  setType(TransactionType type) {
    _type = type;
    notifyListeners();
  }

  setCategory(DocumentReference category) {
    _category = category;
  }

  setMember(DocumentReference member) {
    _member = member;
  }

  setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  setValue(String? value) {
    _value = value;
    notifyListeners();
  }

  setSplitByType(SplitByType splitByType) {
    _splitByType = splitByType;
    notifyListeners();
  }

  clearTo() {
    _to.clear();
    notifyListeners();
  }

  addTo(DocumentReference member) {
    _to.add(member);
    notifyListeners();
  }

  // TODO set 'to'

  // TODO set split by weights

  bool isValidExpense() {
    if (_type != TransactionType.expense) {
      setValue('invalid_type'.tr);
      return false;
    }
    if (currency == null) {
      setValue('currency_cannot_be_empty'.tr);
      return false;
    }
    if (_category == null) {
      setValue('category_cannot_be_empty'.tr);
      return false;
    }
    if (_member == null) {
      setValue('member_cannot_be_empty'.tr);
      return false;
    }
    if (_date == null) {
      setValue('date_cannot_be_empty'.tr);
      return false;
    }
    if (_value == null || double.tryParse(_value!) == null || double.tryParse(_value!)! <= 0) {
      setValue('invalid_value'.tr);
      return false;
    }
    return true;
  }

  bool isValidTransfer() {
    if (_type != TransactionType.transfer) {
      setValue('invalid_type'.tr);
      return false;
    }
    if (currency == null) {
      setValue('currency_cannot_be_empty'.tr);
      return false;
    }
    if (_member == null) {
      setValue('member_cannot_be_empty'.tr);
      return false;
    }
    if (_date == null) {
      setValue('date_cannot_be_empty'.tr);
      return false;
    }
    if (_value == null || double.tryParse(_value!) == null || double.tryParse(_value!)! <= 0) {
      setValue('invalid_value'.tr);
      return false;
    }
    return true;
  }

  bool isValidIncome() {
    if (_type != TransactionType.income) {
      setValue('invalid_type'.tr);
      return false;
    }
    if (currency == null) {
      setValue('currency_cannot_be_empty'.tr);
      return false;
    }
    if (_date == null) {
      setValue('date_cannot_be_empty'.tr);
      return false;
    }
    if (_member == null) {
      setValue('member_cannot_be_empty'.tr);
      return false;
    }
    if (_value == null || double.tryParse(_value!) == null || double.tryParse(_value!)! <= 0) {
      setValue('invalid_value'.tr);
      return false;
    }
    return true;
  }

  clear() {
    _type = TransactionType.expense;
    _category = null;
    _member = null;
    _date = DateTime.now();
    _value = null;
    _to.clear();
    _splitByType = null;
    _splitByWeights = null;
    _groupId = null;
    _groupIcon = null;
    setCurrency(null);
    setExchangeRate(null);
  }
}
