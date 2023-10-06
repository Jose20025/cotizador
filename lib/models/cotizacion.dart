class Cotizacion {
  double superficie;
  double precioMetroCuadrado;
  double? montoTotal;
  double? cuotaInicial;
  int tiempo;
  DateTime? fecha;
  String referencia;
  double? importeCuotas;
  String proyecto;

  Cotizacion({
    required this.superficie,
    required this.precioMetroCuadrado,
    required this.referencia,
    this.cuotaInicial,
    required this.fecha,
    required this.importeCuotas,
    required this.tiempo,
    required this.montoTotal,
    required this.proyecto,
  });

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      superficie: json['superficie'],
      referencia: json['referencia'],
      proyecto: json['proyecto'],
      precioMetroCuadrado: json['precioMetroCuadrado'],
      fecha: DateTime.parse(json['fecha']),
      montoTotal: json['montoTotal'],
      tiempo: json['tiempo'],
      cuotaInicial: json['cuotaInicial'],
      importeCuotas: json['importeCuotas'],
    );
  }

  Map<String, dynamic> toJson() => {
        'superficie': superficie,
        'precioMetroCuadrado': precioMetroCuadrado,
        'cuotaInicial': cuotaInicial,
        'referencia': referencia,
        'tiempo': tiempo,
        'importeCuotas': importeCuotas,
        'fecha': fecha!.toIso8601String(),
        'proyecto': proyecto,
        'montoTotal': montoTotal,
      };
}
