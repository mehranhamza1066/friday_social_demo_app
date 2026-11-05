// -- city with name, lat, lng
// -- fixed list of cities for when location is off

class CityEntity {
  final String name;
  final double lat;
  final double lng;

  const CityEntity({required this.name, required this.lat, required this.lng});
}

// the user can choose one of these when the location is not allowed
const cities = <CityEntity>[
  CityEntity(name: 'London', lat: 51.5072, lng: -0.1276),
  CityEntity(name: 'Paris', lat: 48.8566, lng: 2.3522),
  CityEntity(name: 'New York', lat: 40.7128, lng: -74.0060),
  CityEntity(name: 'Karachi', lat: 24.8607, lng: 67.0011),
  CityEntity(name: 'Dubai', lat: 25.2048, lng: 55.2708),
];
