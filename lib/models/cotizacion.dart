class Cotizacion {
  double interes;
  double? cuotaInicial;
  double montoTotal;
  double tiempo;
  double montoCuotas;

  Cotizacion(
      {required this.interes,
      this.cuotaInicial,
      required this.montoTotal,
      required this.montoCuotas,
      required this.tiempo});

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
        interes: json['interes'],
        montoTotal: json['montoTotal'],
        montoCuotas: json['montoCuotas'],
        tiempo: json['tiempo'],
        cuotaInicial: json['cuotaInicial']);
  }

  Map<String, dynamic> toJson() => {
        'montoTotal': montoTotal,
        'interes': interes,
        'cuotaInicial': cuotaInicial,
        'tiempo': tiempo,
        'montoCuotas': montoCuotas,
      };
}
