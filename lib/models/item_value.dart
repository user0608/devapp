import 'dart:convert';

List<ItemValue> itemValueFromJson(String str) =>
    List<ItemValue>.from(json.decode(str).map((x) => ItemValue.fromMap(x)));

String itemValueToJson(List<ItemValue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ItemValue {
  String? id;
  String? name;
  String? description;
  String? value;
  bool? state;

  ItemValue({
    this.id,
    this.name,
    this.description,
    this.value,
    this.state,
  });

  ItemValue copyWith({
    String? id,
    String? name,
    String? description,
    String? value,
    bool? state,
  }) =>
      ItemValue(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        value: value ?? this.value,
        state: state ?? this.state,
      );

  factory ItemValue.fromMap(Map<String, dynamic> json) => ItemValue(
        name: json["name"],
        id: json["id"],
        description: json["description"],
        value: json["value"],
        state: json["state"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
        "description": description,
        "value": value,
        "state": state,
      };
}
