class Cotizacion {
  double superficie;
  double precioMetroCuadrado;
  double? montoTotal;
  double? cuotaInicial;
  double? mantenimiento;
  int tiempo;
  String? fecha;
  String referencia;
  double? importeCuotas;
  double? montoPagar;

  Cotizacion(
      {required this.superficie,
      required this.precioMetroCuadrado,
      required this.tiempo,
      required this.referencia,
      this.montoTotal,
      this.mantenimiento,
      this.fecha,
      this.cuotaInicial,
      this.importeCuotas,
      this.montoPagar});

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      superficie: json['superficie'],
      referencia: json['referencia'],
      precioMetroCuadrado: json['precioMetroCuadrado'],
      fecha: json['fecha'],
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
        'referencia': referencia,
        'tiempo': tiempo,
        'importeCuotas': importeCuotas,
        'mantenimiento': mantenimiento,
        'fecha': fecha,
        'montoTotal': montoTotal,
        'montoPagar': montoPagar,
      };
}
