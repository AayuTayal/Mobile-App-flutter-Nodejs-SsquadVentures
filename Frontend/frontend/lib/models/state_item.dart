class StateItem {
  final String name;
  final List<String> cities;

  StateItem({required this.name, required this.cities});

  factory StateItem.fromJson(Map<String, dynamic> j) =>
      StateItem(name: j['name'], cities: List<String>.from(j['cities']));
}
