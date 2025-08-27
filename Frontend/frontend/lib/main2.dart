import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

//Have to make API dynamic depending on the platform
final apiBase =
    kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS
    ? 'http://localhost:4000'
    : 'https://276077cee547.ngrok-free.app'; // for real android device

//In Backend the GetOfferWithin field is stored as Number because it will help finding the requests which deadline is near
// But in the frontend inside the Banquet&Venue screen we are keeping it usual, so we have to map hours(int) to days and week(string)
const Map<int, String> offerWithinOptions = {
  24: "24 hours",
  48: "2 days",
  72: "3 days",
  168: "1 week",
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banquets & Venues',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E67F8)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

/* ---------------API Section---------------- */
class Api {
  static Future<List<Category>> fetchCategories() async {
    final r = await http.get(Uri.parse('$apiBase/api/categories'));
    final data = jsonDecode(r.body) as List;
    return data.map((e) => Category.fromJson(e)).toList();
  }

  static Future<Filters> fetchFilters() async {
    final r = await http.get(Uri.parse('$apiBase/api/venues/filters'));
    final data = jsonDecode(r.body);
    return Filters.fromJson(data);
  }

  static Future<String?> submitRequest(BanquetRequest req) async {
    final r = await http.post(
      Uri.parse('$apiBase/api/venues/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );
    if (r.statusCode >= 400) throw Exception(r.body);

    final decoded = jsonDecode(r.body);
    return decoded['id'] != null ? decoded['id'] as String : null;
  }
}

/* ---------------- MODELS SECTION ---------------- */
class Category {
  final String id;
  final String name;
  final String image;
  Category({required this.id, required this.name, required this.image});
  factory Category.fromJson(Map<String, dynamic> j) =>
      Category(id: j['_id'], name: j['name'], image: j['image']);
}

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

class Country {
  final String name;
  final List<StateItem> states;
  Country({required this.name, required this.states});
  factory Country.fromJson(Map<String, dynamic> j) => Country(
    name: j['name'],
    states: (j['states'] as List).map((e) => StateItem.fromJson(e)).toList(),
  );
}

class StateItem {
  final String name;
  final List<String> cities;
  StateItem({required this.name, required this.cities});
  factory StateItem.fromJson(Map<String, dynamic> j) =>
      StateItem(name: j['name'], cities: List<String>.from(j['cities']));
}

class BanquetRequest {
  final String eventType;
  final String country;
  final String state;
  final String city;
  final List<String> eventDates; // changed
  final int numberOfAdults; // changed
  final List<String> cateringPreference; // changed
  final List<String> cuisines;
  final Map<String, dynamic>? budget; // changed
  final int getOfferWithin; // hours

  BanquetRequest({
    required this.eventType,
    required this.country,
    required this.state,
    required this.city,
    required this.eventDates,
    required this.numberOfAdults,
    required this.cateringPreference,
    required this.cuisines,
    this.budget,
    this.getOfferWithin = 48,
  });

  Map<String, dynamic> toJson() => {
    'eventType': eventType,
    'country': country,
    'state': state,
    'city': city,
    'eventDates': eventDates,
    'numberOfAdults': numberOfAdults,
    'cateringPreference': cateringPreference,
    'cuisines': cuisines,
    'budget': budget,
    'getOfferWithin': getOfferWithin,
  };
}

/* ------------------UI SECTION---------------------- */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _future;
  String _searchQuery = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = Api.fetchCategories();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final allItems = snap.data ?? [];

          // Case-insensitive partial match
          final displayed = _searchQuery.trim().isEmpty
              ? allItems
              : allItems
                    .where(
                      (c) => c.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    // ---------- Fixed Top Section ----------
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username + avatar
                          Row(
                            children: [
                              const CircleAvatar(radius: 20, child: Text('S')),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Raghav Sharma',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Free plan + bids card
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Free plan',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'You have 3 bids left. Upgrade now to Bid more.',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Bid left: 3',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Search bar
                          TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        setState(() => _searchQuery = "");
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          ),
                          const SizedBox(height: 16),

                          // ---------- Categories Title ----------
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // ---------- Scrollable Categories ----------
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: displayed.length,
                        itemBuilder: (context, index) {
                          final c = displayed[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (c.name.toLowerCase().contains(
                                    'banquet',
                                  )) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const BanquetFormScreen(),
                                      ),
                                    );
                                  }
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          c.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const SizedBox(
                                                height: 140,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          c.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BanquetFormScreen extends StatefulWidget {
  const BanquetFormScreen({super.key});
  @override
  State<BanquetFormScreen> createState() => _BanquetFormScreenState();
}

class _BanquetFormScreenState extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Filters
  Filters? filters;
  Country? selectedCountry;
  StateItem? selectedState;

  // Controllers for fields
  final TextEditingController _adultsCtrl = TextEditingController();
  final TextEditingController _budgetCtrl = TextEditingController();

  // Values
  String? eventType;
  String? country;
  String? state;
  String? city;
  List<DateTime> dates = [];
  int adults = 0;

  bool veg = false;
  bool nonVeg = false;

  Set<String> cuisines = {};
  int? budget;
  String? currency;
  int? getOfferWithin;

  bool _submitting = false;
  bool _showSectionErrors = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _adultsCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final f = await Api.fetchFilters();
    setState(() {
      filters = f;
    });
  }

  String _fmt(DateTime d) => DateFormat("d MMM yyyy").format(d);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );
    if (d != null) setState(() => dates.add(d));
  }

  @override
  Widget build(BuildContext context) {
    final f = filters;
    return Scaffold(
      appBar: AppBar(title: const Text("Banquets & Venues")),
      body: f == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _sectionTitle("Tell Us Your Venue Requirements"),
                    const SizedBox(height: 12),

                    // Event Type
                    DropdownButtonFormField<String>(
                      initialValue: eventType,
                      decoration: const InputDecoration(
                        labelText: "Event Type *",
                        border: OutlineInputBorder(),
                      ),
                      items: f.eventTypes
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => eventType = v),
                      validator: (v) => v == null ? "Select event type" : null,
                    ),
                    const SizedBox(height: 12),

                    // Country
                    DropdownButtonFormField<String>(
                      initialValue: country,
                      decoration: const InputDecoration(
                        labelText: "Country *",
                        border: OutlineInputBorder(),
                      ),
                      items: f.countries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          country = v;
                          selectedCountry = f.countries.firstWhere(
                            (c) => c.name == v,
                          );
                          state = null;
                          city = null;
                          selectedState = null;
                        });
                      },
                      validator: (v) => v == null ? "Select country" : null,
                    ),
                    const SizedBox(height: 12),

                    // State
                    DropdownButtonFormField<String>(
                      initialValue: state,
                      decoration: const InputDecoration(
                        labelText: "State *",
                        border: OutlineInputBorder(),
                      ),
                      items: (selectedCountry?.states ?? [])
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.name,
                              child: Text(s.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          state = v;
                          selectedState = selectedCountry?.states.firstWhere(
                            (s) => s.name == v,
                          );
                          city = null;
                        });
                      },
                      validator: (v) => v == null ? "Select state" : null,
                    ),
                    const SizedBox(height: 12),

                    // City
                    DropdownButtonFormField<String>(
                      initialValue: city,
                      decoration: const InputDecoration(
                        labelText: "City *",
                        border: OutlineInputBorder(),
                      ),
                      items: (selectedState?.cities ?? [])
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => city = v),
                      validator: (v) => v == null ? "Select city" : null,
                    ),
                    const SizedBox(height: 12),

                    // Dates
                    _datesPicker(),
                    if (_showSectionErrors && dates.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Please add at least one date",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Adults
                    TextFormField(
                      controller: _adultsCtrl,
                      decoration: const InputDecoration(
                        labelText: "Number of Adults *",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => adults = int.tryParse(v) ?? 0,
                      validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0
                          ? "Enter valid number"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Catering
                    _catering(),
                    if (_showSectionErrors && !(veg || nonVeg))
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select at least one catering option",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Cuisines
                    _cuisines(f.cuisines),
                    if (_showSectionErrors && cuisines.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Please select at least one cuisine",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Budget
                    _budget(),
                    const SizedBox(height: 12),

                    // Offer within
                    _getOfferWithinDropdown(),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitting ? null : _confirmBeforeSubmit,
                        child: _submitting
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Text("Submit Request"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionTitle(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    ),
  );

  Widget _datesPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Event Dates *"),
        const SizedBox(height: 8),
        ...dates.map(
          (d) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              readOnly: true,
              initialValue: _fmt(d),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => dates.remove(d)),
                ),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.add),
          label: const Text("Add more dates"),
        ),
      ],
    );
  }

  Widget _catering() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Catering Preference *"),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                value: veg,
                onChanged: (v) => setState(() => veg = v ?? false),
                // small green dot + text
                title: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.green, size: 14),
                    SizedBox(width: 6),
                    Text("Veg"),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CheckboxListTile(
                value: nonVeg,
                onChanged: (v) => setState(() => nonVeg = v ?? false),
                // small red dot + text
                title: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.red, size: 14),
                    SizedBox(width: 6),
                    Text("Non-veg"),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cuisines(List<String> all) {
    // map cuisine names to image URLs (replace with your preferred URLs or local assets)
    final cuisineImages = {
      "Indian":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Indian_cuisine.jpg",
      "Italian":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Italian_cuisine.jpeg",
      "Asian":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Asian_cuisine.jpg",
      "Mexican":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Mexican_cuisine.jpg",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Please select your Cuisines *"),
        const SizedBox(height: 8),
        Column(
          children: all.map((c) {
            final selected = cuisines.contains(c);
            return GestureDetector(
              onTap: () {
                // toggle multi-select on tap
                setState(() {
                  if (selected) {
                    cuisines.remove(c);
                  } else {
                    cuisines.add(c);
                  }
                });
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // cuisine image (left)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        cuisineImages[c] ?? "https://via.placeholder.com/90",
                        width: 90,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 90,
                          height: 70,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.fastfood),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // cuisine name
                    Expanded(
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // trailing checkbox (multi-select)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        value: selected,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              cuisines.add(c);
                            } else {
                              cuisines.remove(c);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _budget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Budget *"),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _budgetCtrl,
                decoration: const InputDecoration(
                  labelText: "Amount *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => budget = int.tryParse(v),
                validator: (v) =>
                    (int.tryParse(v ?? '') ?? 0) <= 0 ? "Enter budget" : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: currency,
                decoration: const InputDecoration(
                  labelText: "Currency *",
                  border: OutlineInputBorder(),
                ),
                items: const ["INR", "USD", "EUR"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => currency = v),
                validator: (v) => v == null ? "Select currency" : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getOfferWithinDropdown() {
    return DropdownButtonFormField<int>(
      initialValue: getOfferWithin,
      decoration: const InputDecoration(
        labelText: "Get Offer Within",
        border: OutlineInputBorder(),
      ),
      items: offerWithinOptions.entries
          .map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: (v) => setState(() => getOfferWithin = v),
    );
  }

  /// Confirm before submit
  Future<void> _confirmBeforeSubmit() async {
    FocusScope.of(context).unfocus(); // close keyboard
    setState(() => _showSectionErrors = true); // show inline section errors

    // Validate all fields + required sections
    final fieldsValid = _formKey.currentState!.validate();
    final sectionsValid =
        dates.isNotEmpty && cuisines.isNotEmpty && (veg || nonVeg);

    if (!fieldsValid || !sectionsValid) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the required details")),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm submission"),
        content: const Text(
          "Are you sure all the details are correct and you want to submit?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes, submit"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _submit();
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      // Transform veg/nonVeg to backend array
      final catering = <String>[];
      if (veg) catering.add("Veg");
      if (nonVeg) catering.add("Non-Veg");

      // Transform budget to backend object
      Map<String, dynamic>? budgetObj;
      if (budget != null && currency != null) {
        budgetObj = {'amount': budget, 'currency': currency};
      }

      final req = BanquetRequest(
        eventType: eventType!,
        country: country!,
        state: state!,
        city: city!,
        eventDates: dates
            .map((d) => DateFormat("yyyy-MM-dd").format(d))
            .toList(),
        numberOfAdults: int.tryParse(_adultsCtrl.text) ?? 0,
        cateringPreference: catering,
        cuisines: cuisines.toList(),
        budget: budgetObj,
        getOfferWithin: getOfferWithin ?? 48,
      );

      // Call API and handle nullable id
      final String? id = await Api.submitRequest(req);
      if (!mounted) return;

      _resetForm(); // clear everything after success

      if (id != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Request submitted successfully! ID: $id"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Request submitted successfully, but no ID returned.",
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _resetForm() {
    setState(() {
      eventType = null;
      country = null;
      state = null;
      city = null;

      selectedCountry = null;
      selectedState = null;

      dates = [];
      cuisines.clear();

      _adultsCtrl.clear();
      adults = 0;

      // Catering reset
      veg = false;
      nonVeg = false;

      _budgetCtrl.clear();
      budget = null;

      // Clear dropdowns
      currency = null;
      getOfferWithin = null;

      _showSectionErrors = false;
    });

    _formKey.currentState?.reset();
  }
}
