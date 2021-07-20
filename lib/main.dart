import 'package:flutter/material.dart';
import 'calced_item.dart';
import 'models/money_items.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'db.dart';

void main() async {
  runApp(MyApp());
}

// Define a function that inserts dogs into the database
Future<void> insertShowItem(ShowItem item) async {
  final db = await DBProvider().db;

  await db.insert(
    'show_item',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the dogs from the dogs table.
Future<List<ShowItem>> showItems() async {
  // Get a reference to the database.
  final db = await DBProvider().db;

  final List<Map<String, dynamic>> maps = await db.query('show_item');

  return List.generate(maps.length, (i) {
    return ShowItem.fromJson(maps[i]);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '现金流',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '收益表'),
    );
  }
}

class _MyHomePageScope extends InheritedWidget {
  const _MyHomePageScope({
    Key? key,
    required Widget child,
    required _MyHomePageState state,
  })  : _state = state,
        super(key: key, child: child);

  final _MyHomePageState _state;

  @override
  bool updateShouldNotify(_MyHomePageScope old) => _state != old._state;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  static _MyHomePageState? of(BuildContext context) {
    final _MyHomePageScope? scope =
        context.dependOnInheritedWidgetOfExactType<_MyHomePageScope>();
    return scope?._state;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var items = <ShowItem>[];
  var incomeItems = new Map<String, ShowItem>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState(){
    super.initState();
    initItems();
  }

  void initItems() async{
    items = await showItems();
  }
  void _incrementCounter() {
    setState(() {
      items.add(ShowItem());
    });
  }

  // var listKey = GlobalKey<>();
  Widget _showItemList() {
    return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index >= items.length) {
            if (items.length > 0)
              return new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                      // if (_formKey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(SnackBar(content: Text('Processing Data')));
                      // }
                      for (var i = 0; i < items.length; ++i) {
                        if (items[i].id != 0) {
                          //todo: use update
                          insertShowItem(items[i]);
                        } else {
                          insertShowItem(items[i]);
                        }
                      }
                    },
                    child: Text('Submit'),
                  ));
            else {
              return new Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Text('Add first item to enjoy cash flow'),
              );
            }
          }
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(items[index].hashCode.toString()),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${items[index].name} dismissed')));
            },
            child: new ShowItemWidget(id: index),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _MyHomePageScope(
        state: this,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: _showItemList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
