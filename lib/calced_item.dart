import 'package:flutter/material.dart';
import 'main.dart';

enum CalcedType {
  Unknown,
  Income,
  Outcome,
}

class ShowItem {
  String name;
  double money;
  CalcedType type;

  ShowItem(
      {this.name = "default", this.money = 0.0, this.type = CalcedType.Income});
}

class ShowItemWidget extends StatefulWidget {
  final int id;

  ShowItemWidget({Key? key, required this.id}) : super(key: key);

  @override
  _ShowItemWidgetState createState() => _ShowItemWidgetState(this.id);
}

class _ShowItemWidgetState extends State<ShowItemWidget> {
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  final ShowItem item = new ShowItem();
  final int id;

  _ShowItemWidgetState(this.id);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Row(
          children: <Widget>[
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text(MyHomePage.of(context)?.items[id].type == CalcedType.Income ? "收入": "支出"),
              ),
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: new TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'name',
                  ),
                  onChanged: (v) {
                    MyHomePage.of(context)?.items[id].name = v;
                  },
                ),
              ),
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'amount',
                  ),
                  onChanged: (v) {
                    var a = double.tryParse(v);
                    if (a == null) return;
                    MyHomePage.of(context)?.items[id].money = a;
                  },
                  validator: (v) {
                    return double.tryParse(v ?? "null") != null
                        ? null
                        : "amount 必须是 double";
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
