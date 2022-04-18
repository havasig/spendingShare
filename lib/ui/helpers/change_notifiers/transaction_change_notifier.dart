import 'package:cloud_firestore/cloud_firestore.dart';
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
  double? _value;
  Member? _from;
  final List<Member> _to = [];
  double? _exchangeRate;
  SplitByType? _splitByType;
  String? _splitByWeights;

  get type => _type;

  get category => _category;

  get member => _member;

  get date => _date;

  get value => _value;

  get from => _from;

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

  setValue(double value) {
    _value = value;
    notifyListeners();
  }

  setFrom(Member from) {
    _from = from;
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

  bool validateFirstPage() {
    if (_type == null) return false;
    if (currency == null) return false;
    if (_category == null) return false;
    if (_from == null && _to.isEmpty) return false;
    if (_date == null) return false;
    if (_value == null && _value! <= 0) return false;
    return true;
  }

  bool validateSecondPage() {
    if (name == null) return false;
    if (_to.isEmpty) return false;
    return true;
  }
}
