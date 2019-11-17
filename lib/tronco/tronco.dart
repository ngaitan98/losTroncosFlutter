class Tronco{
  double lat;
  double lon;
  String especie;
  String estado;
  String id;
  Tronco(String id, double lat, double lon, String especie, String estado){
    this.especie = especie;
    this.estado = estado;
    this.lat = lat;
    this.lon = lon;
    this.id = id;
  }
}