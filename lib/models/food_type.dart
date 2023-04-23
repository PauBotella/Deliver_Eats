class FoodType {
  String type;
  FoodType({required this.type});

  factory FoodType.fromJson(Map<String, dynamic> json) {
    print('FOOD JSON'+ json['type']);
    return FoodType(type: json['type']);
  }
}