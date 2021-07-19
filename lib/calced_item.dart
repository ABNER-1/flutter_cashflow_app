import 'package:flutter/material.dart';


class ShowItem {
  final String text;
  ShowItem(this.text){}
}

enum CalcedType {
  Unknown,
  Income,
  Outcome,
}

class CalcedItem {
  String name;
  double money;
  CalcedType type;
  CalcedItem({this.name="default", this.money = 0.0, this.type = CalcedType.Income});
}

class ShowItemWidget extends StatefulWidget {
  @override
  _ShowItemWidgetState createState() => _ShowItemWidgetState();
}


class _ShowItemWidgetState extends State<ShowItemWidget> {
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  final CalcedItem item = new CalcedItem();
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: <Widget>[
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: new TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'name',
                ),
                onChanged: (v) {
                  item.name = v;
                } ,
              ),
            ),
          ),
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'amount',
                ),
                onChanged: (v) {
                  var a = double.tryParse(v);
                  if(a != null) item.money = a;
                  print(item.money);
                },
                validator: (v) {
                  return double.tryParse(v ?? "null") != null? null : "amount 必须是 double";
                },
              ),
              ),
            ),
        ],
      )
    );
  }
}
