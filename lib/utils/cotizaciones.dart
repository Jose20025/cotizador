import '../models/cotizacion.dart';
import 'proyectos.dart';

Cotizacion crearCotizacion(double precioMetroCuadrado, double superficie,
    double? cuotaInicial, int tiempo, String referencia, int numeroProyecto) {
  double montoTotal = superficie * precioMetroCuadrado;

  if (cuotaInicial != null) {
    montoTotal -= cuotaInicial;
  }

  final mantenimiento = obtenerMontoMantenimiento(montoTotal);

  final montoPagar = (montoTotal + mantenimiento);

  final importeCuotas = montoPagar / tiempo;

  return Cotizacion(
    superficie: superficie,
    precioMetroCuadrado: precioMetroCuadrado,
    tiempo: tiempo,
    referencia: referencia,
    cuotaInicial: cuotaInicial,
    importeCuotas: importeCuotas,
    montoTotal: montoTotal,
    fecha: DateTime.now(),
    proyecto: proyectos[numeroProyecto]!,
  );
}

double obtenerMontoMantenimiento(double monto) {
  return monto * 8 / 100 * 10;
}
