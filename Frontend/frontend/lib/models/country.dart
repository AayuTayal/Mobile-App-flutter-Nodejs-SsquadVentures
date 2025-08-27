import 'state_item.dart';

class Country {
  final String name;
  final List<StateItem> states;

  Country({required this.name, required this.states});

  factory Country.fromJson(Map<String, dynamic> j) => Country(
    name: j['name'],
    states: (j['states'] as List).map((e) => StateItem.fromJson(e)).toList(),
  );
}
