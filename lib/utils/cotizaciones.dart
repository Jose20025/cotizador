import '../models/cotizacion.dart';
import 'proyectos.dart';

Cotizacion crearCotizacion(double precioMetroCuadrado, double superficie,
    double cuotaInicial, int tiempo, String referencia, int numeroProyecto) {
  double montoTotal = superficie * precioMetroCuadrado;

  montoTotal -= cuotaInicial;

  final mantenimiento = obtenerMontoMantenimiento(montoTotal, tiempo);

  final montoPagar = (montoTotal + mantenimiento);

  final importeCuotas = montoPagar / tiempo;

  return Cotizacion(
    superficie: superficie,
    precioMetroCuadrado: precioMetroCuadrado,
    tiempo: tiempo,
    referencia: referencia,
    cuotaInicial: cuotaInicial,
    importeCuotas: importeCuotas,
    montoTotal: (montoPagar + cuotaInicial),
    fecha: DateTime.now(),
    proyecto: proyectos[numeroProyecto]!,
  );
}

double obtenerMontoMantenimiento(double monto, int tiempoMeses) {
  return monto * 8 / 100 * (tiempoMeses / 12);
}
