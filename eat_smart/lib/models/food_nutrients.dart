class FoodNutrients {
  int nutrientId;
  String nutrientName;
  String nutrientNumber;
  String unitName;
  double value;

  FoodNutrients(
      {required this.nutrientId,
        required this.nutrientName,
        required this.nutrientNumber,
        required this.unitName,
        required this.value});

  FoodNutrients.fromJson(Map<String, dynamic> json)
      : nutrientId = json['nutrientId'],
        nutrientName = json['nutrientName'],
        nutrientNumber = json['nutrientNumber'],
        unitName = json['unitName'],
        value = json['value'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nutrientId'] = nutrientId;
    data['nutrientName'] = nutrientName;
    data['nutrientNumber'] = nutrientNumber;
    data['unitName'] = unitName;
    data['value'] = value;
    return data;
  }
}