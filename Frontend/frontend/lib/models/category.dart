class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> j) =>
      Category(id: j['_id'], name: j['name'], image: j['image']);
}
