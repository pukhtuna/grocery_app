import 'package:flutter/material.dart';
import 'package:grocery_app/helper/database_helper.dart';
import 'package:grocery_app/models/grocery_item.dart';

class GroceryStoreProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<GroceryStoreItem> _groceryStoreItems = [];
  List<GroceryStoreItem> get groceryStoreItems => _groceryStoreItems;

  Future<void> getGroceryStoreItems() async {
    _groceryStoreItems = await databaseHelper.getGroceryStoreItems();
    notifyListeners();
  }

  Future<void> addGroceryStoreItem(GroceryStoreItem groceryStoreItem) async {
    await databaseHelper.addGroceryStoreItem(groceryStoreItem);
    _groceryStoreItems.add(groceryStoreItem);
    notifyListeners();
  }

  Future<void> updateGroceryStoreItem(GroceryStoreItem groceryStoreItem) async {
    await databaseHelper.updateGroceryStoreItem(groceryStoreItem);
    notifyListeners();
  }

  Future<void> deleteGroceryStoreItem(GroceryStoreItem groceryStoreItem) async {
    await databaseHelper.deleteGroceryStoreItem(groceryStoreItem.id!);
    _groceryStoreItems.remove(groceryStoreItem);
    notifyListeners();
  }
}
