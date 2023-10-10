class Asesor {
  final String name;
  final String number;

  Asesor({required this.name, required this.number});

  factory Asesor.fromJson(Map<String, dynamic> json) => Asesor(
        name: json['name'],
        number: json['number'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
      };
}
