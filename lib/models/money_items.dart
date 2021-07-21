enum CalcedType {
  Unknown,
  Income,
  Outcome,
}

class MoneyItem {
  int id;
  String name;
  double money;
  CalcedType type;

  MoneyItem(
      {this.id = 0,
      this.name = "default",
      this.money = 0.0,
      this.type = CalcedType.Income});

  Map<String, dynamic> toMap() {
    var typeId = -1;
    if (type == CalcedType.Income) {
      typeId = 1;
    } else if (type == CalcedType.Outcome) {
      typeId = 2;
    }
    return {
      'id': id == 0 ? null : id,
      'name': name,
      'money': money,
      'type': typeId,
    };
  }

  factory MoneyItem.fromJson(Map<String, dynamic> parsedJson) {
    var type = CalcedType.Unknown;
    var typeId = parsedJson['type'];
    if (typeId == 1) {
      type = CalcedType.Income;
    } else if (typeId == 2) {
      type = CalcedType.Outcome;
    }
    return MoneyItem(
      id: parsedJson['id'],
      name: parsedJson['name'],
      money: parsedJson['money'],
      type: type,
    );
  }
}
