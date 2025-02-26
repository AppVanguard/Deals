import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String routeName = 'search';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  /// A SearchController holds the state of the query text
  /// and triggers updates for suggestion building.
  final SearchController _searchController = SearchController();

  /// Dummy data for demonstrating suggestions.
  final List<String> _items = [
    'Apple',
    'Banana',
    'Orange',
    'Grape',
    'Mango',
    'Pineapple',
    'Cherry',
    'Blueberry',
    // ... add more items
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent app bar background if you wish
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // A leading back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // Use SearchAnchor to show the search bar in the title area
        title: Row(
          spacing: 12,
          children: [
            Expanded(
              child: SearchAnchor.bar(
                barElevation: WidgetStatePropertyAll(0),
                // The SearchController that holds the query text and notifies about changes
                searchController: _searchController,

                // The hint text inside the search bar
                barHintText: 'Search',

                // Customize the appearance of the bar if needed
                // e.g. shape, background color, etc.
                barBackgroundColor:
                    WidgetStateProperty.all(Colors.grey.shade200),

                // An optional trailing icon (e.g., filters)
                // barTrailing: [
                //   IconButton(
                //     icon: const Icon(Icons.filter_list),
                //     onPressed: () {
                //       // TODO: Handle filters
                //     },
                //   ),
                // ],

                // This callback builds the suggestions overlay whenever the user types
                // or the search state changes.
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  final String query = controller.text.trim().toLowerCase();

                  // Filter items by query
                  final List<String> filteredItems = _items
                      .where((item) => item.toLowerCase().contains(query))
                      .toList();

                  // Return a list of widgets that appear in the dropdown.
                  // Typically, you'd return ListTiles or similar.
                  return List<Widget>.generate(filteredItems.length,
                      (int index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        // When an item is tapped, you might update the search field
                        // or navigate somewhere, etc.
                        controller.closeView(item);
                      },
                    );
                  });
                },
              ),
            ),
            SvgPicture.asset(AppImages.assetsImagesIconsFilter,
                width: 24, height: 24),
          ],
        ),
      ),
      body: const SearchViewBody(),
    );
  }
}

class SearchViewBody extends StatelessWidget {
  const SearchViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Put the rest of your page content here.
    return Center(
      child: Text('Search results or other content go here.'),
    );
  }
}
