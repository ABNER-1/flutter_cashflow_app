import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'calced_item.dart';
import 'db.dart';
import 'models/money_items.dart';

void main() async {
  runApp(MyApp());
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
  var items = <MoneyItem>[];
  var incomeItems = new Map<String, MoneyItem>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final rmIcons = false;

  @override
  void initState() {
    super.initState();
    initItems();
  }

  void initItems() async {
    items = await listShowItems();
    setState(() {});
    print("len of items: " + items.length.toString());
  }

  void _addShowItem(CalcedType type) {
    setState(() {
      items.add(MoneyItem(type: type));
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
                      for (var i = 0; i < items.length; ++i) {
                        if (items[i].id != 0) {
                          updateShowItem(items[i]);
                        } else {
                          insertShowItem(items[i]);
                        }
                      }
                    },
                    child: Text('Save'),
                  ));
            else {
              return new Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Text('Add first item to enjoy cash flow'),
              );
            }
          }
          return Dismissible(
            key: Key(items[index].hashCode.toString()),
            onDismissed: (direction) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${items[index].name} dismissed')));
              setState(() {
                if (items[index].id != 0) deleteShowItem(items[index].id);
                items.removeAt(index);
              });
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
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 3,
            openCloseDial: ValueNotifier<bool>(false),
            childPadding: EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            dialRoot: null,
            buttonSize: 56, // it's the SpeedDial size which defaults to 56 itself
            // iconTheme: IconThemeData(size: 22),
            label: null, // The label of the main button.
            /// The active label of the main button, Defaults to label if not specified.
            activeLabel: null,

            /// Transition Builder between label and activeLabel, defaults to FadeTransition.
            // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
            /// The below button size defaults to 56 itself, its the SpeedDial childrens size
            childrenButtonSize: 56.0,
            visible: true,
            direction: SpeedDialDirection.Up,
            switchLabelPosition: false,

            /// If true user is forced to close dial manually
            closeManually: false,

            /// If false, backgroundOverlay will not be rendered.
            renderOverlay: true,
            // overlayColor: Colors.black,
            overlayOpacity: 0.0,
            onOpen: (){},
            onClose: (){},
            useRotationAnimation: true,
            tooltip: 'Open Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            // foregroundColor: Colors.black,
            // backgroundColor: Colors.white,
            // activeForegroundColor: Colors.red,
            // activeBackgroundColor: Colors.blue,
            elevation: 8.0,
            isOpenOnStart: false,
            animationSpeed: 200,
            shape: StadiumBorder(),
            // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              SpeedDialChild(
                child: !rmIcons ? Icon(Icons.money) : null,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: '收入',
                onTap: () => _addShowItem(CalcedType.Income),
              ),
              SpeedDialChild(
                child: !rmIcons ? Icon(Icons.payment) : null,
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                label: '支出',
                onTap: () => _addShowItem(CalcedType.Outcome),
              ),
              // SpeedDialChild(
              //   child: !rmicons ? Icon(Icons.margin) : null,
              //   backgroundColor: Colors.indigo,
              //   foregroundColor: Colors.white,
              //   label: 'Show Snackbar',
              //   visible: true,
              //   onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text(("Third Child Pressed")))),
              //   onLongPress: () => print('THIRD CHILD LONG PRESS'),
              // ),
            ],
          ),
        ));
  }
}
