import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/enums/split_by_type.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/utils/number_helper.dart';
import 'package:tuple/tuple.dart';

import 'currency_change_notifier.dart';

class CreateTransactionChangeNotifier extends CreateChangeNotifier {
  CreateTransactionChangeNotifier() : super(null);

  TransactionType _type = TransactionType.expense;
  DocumentReference? _category;
  DocumentReference? _member;
  DateTime _date = DateTime.now();
  String _value = '';
  final Map<DocumentReference, Tuple2<String, String>> _to = {};
  SplitByType? _splitByType;
  String? _splitByWeights;
  String? _groupId;
  final Set<DocumentReference> _allMembers = {};
  final Set<DocumentReference> _editedAmountMembers = {};
  String? _color;
  String? _groupIcon;
  DocumentReference? _selectedMember;

  TransactionType get type => _type;

  DocumentReference? get category => _category;

  String? get groupId => _groupId;

  String? get color => _color;

  String? get groupIcon => _groupIcon;

  DocumentReference? get member => _member;

  DateTime get date => _date;

  String get value => _value;

  Map<DocumentReference, Tuple2<String, String>> get to => _to;

  Set<DocumentReference> get allMembers => _allMembers;

  Set<DocumentReference> get editedAmountMembers => _editedAmountMembers;

  DocumentReference? get selectedMember => _selectedMember;

  get splitByType => _splitByType;

  get splitByWeights => _splitByWeights;

  setGroupId(String groupId) {
    _groupId = groupId;
  }

  setAllMembers(List<DocumentReference> allMembers) {
    _allMembers.clear();
    _allMembers.addAll(allMembers);
  }

  clearAllMembers() {
    _allMembers.clear();
  }

  addToAllMembers(DocumentReference item) {
    _allMembers.add(item);
  }

  addEditedAmount(DocumentReference item) {
    _editedAmountMembers.add(item);
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
  }

  setValue(String value) {
    _value = value;
    notifyListeners();
  }

  clearTo() {
    _to.clear();
  }

  clearEditedAmount() {
    _editedAmountMembers.clear();
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
    _to[member] = _to[member]!.withItem1('0');
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

  setSelectedValue(double newValue) {
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
    }
    _to;
    _editedAmountMembers;
    notifyListeners();
  }

  setSelectedWeight(String newValue) {}

  setSelectedMember(DocumentReference newMember) {
    _selectedMember = newMember;
    notifyListeners();
  }

  setSplitByType(SplitByType splitByType) {
    _splitByType = splitByType;
    notifyListeners();
  }

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
    if (_member == null) {
      setValue('member_cannot_be_empty'.tr);
      return false;
    }
    if (_date == null) {
      setValue('date_cannot_be_empty'.tr);
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
    if (_date == null) {
      setValue('date_cannot_be_empty'.tr);
      return false;
    }
    if (_member == null) {
      setValue('member_cannot_be_empty'.tr);
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
    _category = null;
    _member = null;
    _date = DateTime.now();
    _value = '';
    _to.clear();
    _allMembers.clear();
    _splitByType = null;
    _splitByWeights = null;
    _groupId = null;
    _groupIcon = null;
    setCurrency(null);
    setExchangeRate(null);
  }
}
