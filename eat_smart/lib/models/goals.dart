class Goals {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  Goals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': this.calories,
      'protein': this.protein,
      'carbs': this.carbs,
      'fats': this.fats,
    };
  }

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      calories: json['calories'].toDouble(),
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fats: json['fats'].toDouble(),
    );
  }
}
