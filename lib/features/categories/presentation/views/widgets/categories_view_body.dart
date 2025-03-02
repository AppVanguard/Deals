import 'package:flutter/material.dart';
import 'package:deals/features/categories/presentation/views/widgets/category_deal.dart';
import 'package:deals/core/widgets/generic_card.dart';

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({super.key, required this.deals});

  final List<CategoryDeal> deals;

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'All',
      'New stores',
      'Marketplace',
      'Fashion',
      'Food&Drink',
      'Travel',
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          // The TabBar (scrollable horizontally if needed)
          Container(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              tabs: tabs.map((tabText) => Tab(text: tabText)).toList(),
            ),
          ),

          // The TabBarView (each tab has its own content)
          Expanded(
            child: TabBarView(
              children: tabs.map((tabText) {
                // For each tab, show a scrollable ListView of deals
                // (or any other widget you want).
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    return GenericCard(
                      imagePath: deals[index].imagePath,
                      title: deals[index].title,
                      subtitle: deals[index].subtitle,
                      onTap: () {
                        // Handle tap...
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
