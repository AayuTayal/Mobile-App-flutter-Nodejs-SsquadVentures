import 'country.dart';

class Filters {
  final List<String> eventTypes;
  final List<Country> countries;
  final List<String> cuisines;

  Filters({
    required this.eventTypes,
    required this.countries,
    required this.cuisines,
  });

  factory Filters.fromJson(Map<String, dynamic> j) => Filters(
    eventTypes: List<String>.from(j['eventTypes']),
    countries: (j['countries'] as List)
        .map((e) => Country.fromJson(e))
        .toList(),
    cuisines: List<String>.from(j['cuisines']),
  );
}
