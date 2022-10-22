import 'dart:collection';
import 'package:flutter/foundation.dart';

class ItemsModel extends ChangeNotifier {
  final List<String> _items = [];

  UnmodifiableListView<String> get items => UnmodifiableListView(_items);

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
