import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';

class TopStores extends StatelessWidget {
  const TopStores({
    super.key,
    required this.cashbackItems,
  });

  final List<Map<String, String>> cashbackItems;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Horizontal scroll
          child: Column(
            children: [
              // First Row
              Row(
                children:
                    List.generate((cashbackItems.length / 2).toInt(), (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        // Image Card
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Background color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              cashbackItems[index]["image"] ?? '',
                              fit: BoxFit.fill,
                              height: 80, // Set a fixed size for the image
                            ),
                          ),
                        ),
                        // Text under the image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cashbackItems[index]["name"] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Up to 10% Cashback",
                          style: TextStyle(color: AppColors.accent),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              // Second Row
              Row(
                children:
                    List.generate((cashbackItems.length / 2).toInt(), (index) {
                  int adjustedIndex =
                      index + (cashbackItems.length / 2).toInt();
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        // Image Card
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Background color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              cashbackItems[adjustedIndex]["image"] ?? '',
                              fit: BoxFit.fill,
                              height: 80, // Set a fixed size for the image
                            ),
                          ),
                        ),
                        // Text under the image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cashbackItems[adjustedIndex]["name"] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Up to 10% Cashback",
                          style: TextStyle(color: AppColors.accent),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
