// Suggested code may be subject to a license. Learn more: ~LicenseLog:4274021869.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3172779149.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista della spesa',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  List<String> _shoppingList = [];
  final TextEditingController _newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  _loadShoppingList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shoppingList = prefs.getStringList('shoppingList') ?? [];
    });
  }

  void _addItem() {
    if (_newItemController.text.isNotEmpty) {
      setState(() {
        _shoppingList.add(_newItemController.text);
        _newItemController.clear();
        _saveShoppingList();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _shoppingList.removeAt(index);
    });
    _saveShoppingList();
  }

  _saveShoppingList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('shoppingList', _shoppingList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista della spesa')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: const InputDecoration(
                      hintText: 'Aggiungi un elemento',
                    ),
                    onSubmitted:
                        (_) => _addItem(), // Aggiungi con il tasto Invio
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Aggiungi'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                final item = _shoppingList[index];
                return Dismissible(
                  key: Key(
                    item,
                  ), // Ogni elemento deve avere una key univoca per Dismissible
                  onDismissed: (direction) {
                    _removeItem(index);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('$item rimosso')));
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(title: Text(item)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
