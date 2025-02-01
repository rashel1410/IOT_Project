class Nutrient {
  String nutrientName;
  String nutrientNumber;
  String unitName;
  double value;

  Nutrient(
      {required this.nutrientName,
      required this.nutrientNumber,
      required this.unitName,
      required this.value});

  Nutrient.fromJson(Map<String, dynamic> json)
      : nutrientName = json['nutrientName'],
        nutrientNumber = json['nutrientNumber'],
        unitName = json['unitName'],
        value = json['value'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nutrientName'] = nutrientName;
    data['nutrientNumber'] = nutrientNumber;
    data['unitName'] = unitName;
    data['value'] = value;
    return data;
  }
}
