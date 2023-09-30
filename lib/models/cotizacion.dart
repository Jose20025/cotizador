class Cotizacion {
  double superficie;
  double precioMetroCuadrado;
  double? montoTotal;
  double? cuotaInicial;
  double? mantenimiento;
  int tiempo;
  double? importeCuotas;
  double? montoPagar;

  Cotizacion(
      {required this.superficie,
      required this.precioMetroCuadrado,
      required this.tiempo,
      this.montoTotal,
      this.mantenimiento,
      this.cuotaInicial,
      this.importeCuotas,
      this.montoPagar});

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      superficie: json['superficie'],
      precioMetroCuadrado: json['precioMetroCuadrado'],
      montoTotal: json['montoTotal'],
      tiempo: json['tiempo'],
      cuotaInicial: json['cuotaInicial'],
      mantenimiento: json['mantenimiento'],
      importeCuotas: json['importeCuotas'],
      montoPagar: json['montoPagar'],
    );
  }

  Map<String, dynamic> toJson() => {
        'superficie': superficie,
        'precioMetroCuadrado': precioMetroCuadrado,
        'cuotaInicial': cuotaInicial,
        'tiempo': tiempo,
        'importeCuotas': importeCuotas,
        'mantenimiento': mantenimiento,
        'montoTotal': montoTotal,
        'montoPagar': montoPagar,
      };
}
