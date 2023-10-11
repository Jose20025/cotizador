class Asesor {
  String name;
  String number;

  Asesor({required this.name, required this.number});

  factory Asesor.fromJson(Map<String, dynamic> json) => Asesor(
        name: json['name'],
        number: json['number'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
      };

  void changeName(String newName) {
    name = newName;
  }

  void changeNumber(String newNumber) {
    number = newNumber;
  }

  void changeAll(String newName, String newNumber) {
    name = newName;
    number = newNumber;
  }
}
