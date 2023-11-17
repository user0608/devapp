import 'package:devapp/dialogs/access_request_form.dart';
import 'package:devapp/models/item_value.dart';
import 'package:devapp/proferences/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

const key = "list_values";

class ListItemValuesProvider extends ChangeNotifier {
  final _values = <ItemValue>[];
  List<ItemValue> get values => _values;

  Future<void> createValueDialog(BuildContext context) async {
    final value = await showItemValueFormDialog(context);
    if (value == null) return;
    if (!context.mounted) return;
    saveValue(context, value);
  }

  Future<void> updateValueDialog(BuildContext context, ItemValue item) async {
    final value = await showItemValueFormDialog(context, item: item);
    if (value == null) return;
    if (!context.mounted) return;
    updateValue(context, value);
  }

  Future<void> removeItems(BuildContext context, List<ItemValue> items) async {
    if (items.isEmpty) return;
    final aswer = await showConfirmationKDialog(
      context,
      message: "Are you sure you want to proceed with this action?",
    );
    if (!aswer) return;
    bool exist(ItemValue itm) {
      final index = items.indexWhere((element) => element.name == itm.name);
      return index != -1;
    }

    if (!context.mounted) return;
    final filteds = _values.where((element) => !exist(element)).toList();
    await _replaceValues(context, filteds);
    selecteds.clear();
  }

  Future<void> replaceItem(BuildContext context, ItemValue item) async {
    final items = [..._values];
    final index = items.indexWhere((element) => element.name == item.name);
    if (index == -1) return;
    items[index] = item;
    _replaceValues(context, items);
  }

  Future<void> updateValue(BuildContext context, ItemValue value) async {
    final items = [..._values];
    final index = items.indexWhere((element) => element.name == value.name);
    if (index == -1) return;
    items[index] = value;
    _replaceValues(context, items);
  }

  Future<void> saveValue(BuildContext context, ItemValue value) async {
    final index = values.indexWhere((element) => element.name == value.name);
    if (index != -1) {
      await showBottomAlertKDialog(
        context,
        message: "the element ${value.name} is already registered",
      );
      return;
    }
    if (!context.mounted) return;
    final items = [..._values, value];
    _replaceValues(context, items);
  }

  Future<void> _replaceValues(BuildContext context, List<ItemValue> items) async {
    try {
      await SharedPreferencesContentProvider.putString(key, itemValueToJson(items));
      _values.clear();
      _values.addAll(items);
      notifyListeners();
    } catch (err) {
      if (context.mounted) {
        await showBottomAlertKDialog(context, message: err.toString());
      }
    }
  }

  Future<void> loadValues(BuildContext context) async {
    try {
      final result = await SharedPreferencesContentProvider.get(key);
      if (result is! String) return;
      if (result == "") return;
      final value = itemValueFromJson(result);
      _values.clear();
      _values.addAll(value);
      notifyListeners();
    } catch (err) {
      if (context.mounted) {
        await showBottomAlertKDialog(context, message: err.toString());
      }
    }
  }

  final _selectedItems = <ItemValue>[];

  List<ItemValue> get selecteds => _selectedItems;
  bool isSelected(ItemValue item) {
    final index = _selectedItems.indexWhere((element) => element.name == item.name);
    return index != -1;
  }

  void selectItem(ItemValue item) {
    if (isSelected(item)) return;
    _selectedItems.add(item);
    notifyListeners();
  }

  void unSelectItem(ItemValue item) {
    final index = _selectedItems.indexWhere((element) => element.name == item.name);
    if (index == -1) return;
    _selectedItems.removeAt(index);
    notifyListeners();
  }

  void selectAllItems() {
    _selectedItems.clear();
    _selectedItems.addAll(_values);
    notifyListeners();
  }

  void unSelectAllItems() {
    if (_selectedItems.isEmpty) return;
    _selectedItems.clear();
    notifyListeners();
  }
}
