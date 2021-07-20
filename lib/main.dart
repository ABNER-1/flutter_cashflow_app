import 'package:flutter/material.dart';

import 'calced_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '现金流',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  final items = <ShowItem>[];
  var incomeItems = new Map<String, ShowItem>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _incrementCounter() {
    setState(() {
      items.add(ShowItem());
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
              child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${items[index].name} dismissed')));
                      },
                      child: new ShowItemWidget(id: index),
                    );
                  })),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
