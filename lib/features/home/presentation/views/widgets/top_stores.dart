import 'package:flutter/material.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/domain/entities/store_entity.dart';

class TopStores extends StatelessWidget {
  final List<StoreEntity> stores;

  const TopStores({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // We might split them into 2 rows like your old code
              Row(
                children: List.generate((stores.length / 2).ceil(), (index) {
                  final store = stores[index];
                  return _StoreCard(store: store);
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate((stores.length / 2).floor(), (index) {
                  final adjustedIndex = index + (stores.length / 2).ceil();
                  if (adjustedIndex >= stores.length) return const SizedBox();
                  final store = stores[adjustedIndex];
                  return _StoreCard(store: store);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final StoreEntity store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            // Use store.imageUrl from your backend
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                store.imageUrl,
                fit: BoxFit.fill,
                height: 80,
                // Just in case there's an issue with the image
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              store.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Example static text
          const Text(
            "Up to 10% Cashback",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
