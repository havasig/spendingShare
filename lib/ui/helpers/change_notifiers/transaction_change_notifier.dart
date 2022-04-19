import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/enums/split_by_type.dart';
import 'package:spending_share/models/enums/transaction_type.dart';

import 'currency_change_notifier.dart';

class CreateTransactionChangeNotifier extends CreateChangeNotifier {
  CreateTransactionChangeNotifier(_currency) : super(_currency);

  TransactionType _type = TransactionType.expense;
  DocumentReference? _category;
  DocumentReference? _member;
  DateTime? _date = DateTime.now();
  String? _value;
  final List<Member> _to = [];
  double? _exchangeRate;
  SplitByType? _splitByType;
  String? _splitByWeights;

  TransactionType get type => _type;

  get category => _category;

  get member => _member;

  get date => _date;

  String? get value => _value;

  get to => _to;

  get exchangeRate => _exchangeRate;

  get splitByType => _splitByType;

  get splitByWeights => _splitByWeights;

  setType(TransactionType type) {
    _type = type;
    notifyListeners();
  }

  setCategory(DocumentReference category) {
    _category = category;
    notifyListeners();
  }

  setMember(DocumentReference member) {
    _member = member;
    notifyListeners();
  }

  setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  setValue(String? value) {
    _value = value;
    notifyListeners();
  }

  setExchangeRate(double exchangeRate) {
    _exchangeRate = exchangeRate;
    notifyListeners();
  }

  setSplitByType(SplitByType splitByType) {
    _splitByType = splitByType;
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
    if (_value == null || double.tryParse(_value!) == null || double.tryParse(_value!)! <= 0) {
      setValue('invalid_value'.tr);
      return false;
    }
    return true;
  }

  bool validateSecondPage() {
    if (name == null) return false;
    if (_to.isEmpty) return false;
    return true;
  }
}
