import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/number_helper.dart';
import 'package:tuple/tuple.dart';

import 'currency_change_notifier.dart';

class CreateTransactionChangeNotifier extends CreateChangeNotifier {
  CreateTransactionChangeNotifier() : super(null, null);

  TransactionType _type = TransactionType.expense;
  String _value = '';
  final Map<DocumentReference, Tuple2<String, String>> _to = {};
  DocumentReference? _selectedMember;
  final Set<DocumentReference> _editedAmountMembers = {};
  bool _disposed = false;

  TransactionType get type => _type;

  String get value => _value;

  Map<DocumentReference, Tuple2<String, String>> get to => _to;

  DocumentReference? get selectedMember => _selectedMember;

  Set<DocumentReference> get editedAmountMembers => _editedAmountMembers;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  setType(TransactionType type) {
    _type = type;
    notifyListeners();
  }

  setValue(String value) {
    _value = value;
    notifyListeners();
  }

  clearTo() {
    _to.clear();
  }

  addTo(DocumentReference member, String value) {
    _to[member] = _to[member]?.withItem1(value) ?? Tuple2(value, '1');
    notifyListeners();
  }

  recalculateToEqualAdd(DocumentReference member) {
    _to[member] = _to[member]!.withItem1('1');
    int payingCount = _to.entries.where((element) => element.value.item1 != '0').length;

    _to.forEach((key, value) {
      if (value.item1 != '0') {
        _to[key] = Tuple2((double.parse(_value) / payingCount).toString(), '1');
      }
    });
    notifyListeners();
  }

  recalculateToEqualRemove(DocumentReference member) {
    _to[member] = const Tuple2('0', '0');
    int payingCount = _to.entries.where((element) {
      return element.value.item1 != '0';
    }).length;
    _to.forEach((key, value) {
      if (value.item1 != '0') {
        _to[key] = Tuple2((double.parse(_value) / payingCount).toString(), '1');
      }
    });
    notifyListeners();
  }

  setSelectedAmount(double newValue) {
    if (double.tryParse(_value) == null) throw Exception('Shit gets real');
    if (_selectedMember != null) {
      _to[_selectedMember!] = _to[_selectedMember!]!.withItem1(formatNumberString(newValue.toString()));
      _editedAmountMembers.add(_selectedMember!);
      double alreadyEditedSum = 0;
      int toNotNull = 0;
      for (var element in _editedAmountMembers) {
        alreadyEditedSum += double.tryParse(_to[element]?.item1 ?? '') ?? 0;
      }
      _to.forEach((key, value) {
        if (!_editedAmountMembers.contains(key) && to[key]?.item1 != '0') toNotNull++;
      });

      if (alreadyEditedSum >= double.tryParse(_value)!) {
        _value = alreadyEditedSum.toString();
        _to.forEach((key, value) {
          if (!_editedAmountMembers.contains(key)) _to[key] = value.withItem1('0');
        });
      } else if (toNotNull == 0) {
        var result = 0.0;
        _to.forEach((key, value) {
          result += double.parse(value.item1);
        });
        _value = result.toString();
      } else {
        double eachPay = (double.tryParse(_value)! - alreadyEditedSum) / toNotNull;
        _to.forEach((key, value) {
          if (!_editedAmountMembers.contains(key) && _to[key]?.item1 != '0') _to[key] = value.withItem1(eachPay.toString());
        });
      }
      calculateMinimalWeights();
      print('stop');
    }
    notifyListeners();
  }

  int findGCD(Iterable<int> arr) {
    var result = arr.first;
    for (int element in arr) {
      if (element == 0) continue;
      result = result.gcd(element);
      if (result == 1) return 1;
    }
    return result;
  }

  setSelectedWeight(double newWeight) {
    if (_selectedMember != null) {
      _to[_selectedMember!] = _to[_selectedMember!]!.withItem2(formatNumberString(newWeight.toString()));

      double sumWeights = 0.0;
      _to.forEach((key, value) {
        sumWeights += double.parse(value.item2);
      });
      _to.forEach((key, value) {
        _to[key] = value.withItem1(((double.parse(_value) / sumWeights) * double.parse(value.item2)).toString());
      });
    }
    notifyListeners();
  }

  calculateMinimalWeights() {
    Map<DocumentReference, int> values = {};
    _to.forEach((key, value) {
      values[key] = (double.parse(value.item1) * pow(10, globals.decimals)).toInt();
    });
    int gcd = findGCD(values.values);
    if (gcd == 0) {
      _to.forEach((key, value) {
        _to[key] = value.withItem2('0');
      });
    } else {
      _to.forEach((key, value) {
        _to[key] = value.withItem2((values[key]! / gcd).toString());
      });
    }
  }

  clearEditedAmount() {
    _editedAmountMembers.clear();
  }

  setSelectedMember(DocumentReference newMember) {
    _selectedMember = newMember;
    notifyListeners();
  }

  bool isValidExpense() {
    if (_type != TransactionType.expense) {
      setValue('invalid_type'.tr);
      return false;
    }
    if (currency == null) {
      setValue('currency_cannot_be_empty'.tr);
      return false;
    }
    if (_value == '' || double.tryParse(_value) == null || double.tryParse(_value)! <= 0) {
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
    if (_value == '' || double.tryParse(_value) == null || double.tryParse(_value)! <= 0) {
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
    if (_value == '' || double.tryParse(_value) == null || double.tryParse(_value)! <= 0) {
      setValue('invalid_value'.tr);
      return false;
    }
    return true;
  }

  clear() {
    _type = TransactionType.expense;
    _value = '';
    _to.clear();
    setCurrencyNoNotify(null);
    setExchangeRate(null);
    setColorNoNotify(null);
  }
}
