class Cotizacion {
  double interes;
  double? cuotaInicial;
  double montoTotal;
  double tiempo;
  double cuotas;

  Cotizacion(
      {required this.interes,
      this.cuotaInicial,
      required this.montoTotal,
      required this.cuotas,
      required this.tiempo});
}
