class Goals {
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;

  Goals({
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': this.calories,
      'proteins': this.proteins,
      'carbs': this.carbs,
      'fats': this.fats,
    };
  }

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      calories: json['calories'].toDouble(),
      proteins: json['proteins'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fats: json['fats'].toDouble(),
    );
  }
}
