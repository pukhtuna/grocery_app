// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/helper/database_helper.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/provider/grocery_store_provider.dart';
import 'package:grocery_app/utils/shared_code.dart';
import 'package:grocery_app/view/add_item_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final searchController = TextEditingController();
  final databaseHelper = DatabaseHelper();
  List<GroceryStoreItem> itemsList = [];

  fetchData() async {
    setState(() => isLoading = true);
    final gProvider = Provider.of<GroceryStoreProvider>(context, listen: false);
    await gProvider.getGroceryStoreItems();
    itemsList = gProvider.groceryStoreItems;
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
            text: 'Grocery Store',
            fontSize: 22,
            letterSpacing: 1.5,
            color: Colors.white),
        elevation: 0,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(CupertinoIcons.refresh, color: Colors.black),
                    SizedBox(width: 20),
                    CustomText(text: 'Refresh'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 1) {
                await fetchData();
              }
            },
            position: PopupMenuPosition.under,
            shape: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddItemPage()));
        },
        child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle),
            child: const Icon(CupertinoIcons.add, color: Colors.white)),
      ),
      body: Consumer<GroceryStoreProvider>(
          builder: (context, groceryProvider, child) {
        return isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: CupertinoSearchTextField(
                        controller: searchController,
                        suffixMode: OverlayVisibilityMode.editing,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              itemsList = groceryProvider.groceryStoreItems;
                            });
                          } else {
                            setState(() {
                              itemsList = groceryProvider.groceryStoreItems;
                              itemsList = itemsList
                                  .where((element) => element.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: itemsList.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: itemsList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemBuilder: (context, index) {
                                final groceryStoreItem = itemsList[index];
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    color: Colors.deepPurpleAccent
                                        .withOpacity(0.2),
                                  ),
                                  child: ListTile(
                                      title: CustomText(
                                          text: groceryStoreItem.name ?? '',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                      subtitle: CustomText(
                                          text:
                                              'Quantity: ${groceryStoreItem.quantity}'),
                                      contentPadding: const EdgeInsets.only(
                                          left: 16, right: 5),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _nameController.text =
                                                  groceryStoreItem.name ?? '';
                                              _quantityController.text =
                                                  groceryStoreItem.quantity
                                                      .toString();
                                              _priceController.text =
                                                  groceryStoreItem.price
                                                      .toString();
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const CustomText(
                                                      text: 'Edit Item',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    content: Form(
                                                      key: _formKey,
                                                      child: SizedBox(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height /
                                                                4,
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              controller:
                                                                  _nameController,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Name',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter a name.';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  _priceController,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Price',
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter a price.';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  _quantityController,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Quantity',
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter a quantity.';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary)),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const CustomText(
                                                          text: 'Cancel',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          onPressed: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              final updatedItem =
                                                                  GroceryStoreItem(
                                                                id: groceryStoreItem
                                                                    .id,
                                                                name:
                                                                    _nameController
                                                                        .text,
                                                                price: double.parse(
                                                                    _priceController
                                                                        .text),
                                                                quantity: int.parse(
                                                                    _quantityController
                                                                        .text),
                                                              );

                                                              await databaseHelper
                                                                  .updateGroceryStoreItem(
                                                                      updatedItem);
                                                              Navigator.pop(
                                                                  context);
                                                              fetchData();
                                                            }
                                                          },
                                                          child:
                                                              const CustomText(
                                                            text: 'Update',
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.edit,
                                                color: Colors.green),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: CustomText(
                                                      text:
                                                          'Delete ${groceryStoreItem.name}',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    content: const CustomText(
                                                        text:
                                                            'Are you sure you want to delete this item?'),
                                                    actions: [
                                                      TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const CustomText(
                                                            text: 'No',
                                                            color: Colors.white,
                                                          )),
                                                      TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          onPressed: () async {
                                                            await databaseHelper
                                                                .deleteGroceryStoreItem(
                                                                    groceryStoreItem
                                                                        .id!);
                                                            Navigator.pop(
                                                                context);
                                                            fetchData();
                                                          },
                                                          child:
                                                              const CustomText(
                                                            text: 'Yes',
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.delete,
                                                color: Colors.red),
                                          ),
                                        ],
                                      )),
                                );
                              },
                            )
                          : const Center(
                              child: EmptyPageText(
                              text: 'Press + to add items!',
                              fontSize: 21,
                            )),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
