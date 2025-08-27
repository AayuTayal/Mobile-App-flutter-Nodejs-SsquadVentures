import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api.dart';
import 'banquet_venue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //it will fetch categories from API
  late Future<List<Category>> _future;
  // it will store the search query for the search bar present in the Home Screen
  String _searchQuery = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    //it will fetch the categories as soon as the screen initializes
    _future = Api.fetchCategories();
  }

  @override
  void dispose() {
    //disposing search controller to free resources
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (context, snap) {
          //it will show the loading spinner when fetching data
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Showing error message if the API call fails
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final allItems = snap.data ?? [];
          // it will filter the categories based on the search data
          final displayed = _searchQuery.trim().isEmpty
              ? allItems
              : allItems
                    .where(
                      (c) => c.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();

          // SafeArea will ensure that the UI is not blocked by notch/status bar
          // I have used center+constrained box to keep the UI at center when viewing on wider screens to make UI look good
          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    /*-----This is the top section where we have user+ Plans & Bids section + search bar----*/
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*-----Username + avatar------*/
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
                                  //overflow: TextOverflow.ellipsis //firstly I used this to avoid overflow and truncate the text by showing ellipsis but no need of this because we want to show the full user name even it comes in next line,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          /*---------Free plan + bids card-------------*/
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

                          /*-------Search bar for filtering Categories--------*/
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

                          /*---------- Categories Title ----------*/
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

                    /*---------- Categories List----------*/
                    //This is kept scrollable while the top section(username + Plans&Bids+ search bar) is kept fixed
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
                                      //Here we are adding images for categories with fixed aspect ratio, fetching from database
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
                                      //Category name which is present below the category image
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
