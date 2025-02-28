// top_stores.dart

import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/home/domain/entities/store_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';

class TopStores extends StatelessWidget {
  final List<StoreEntity> stores;
  final bool isLoading;

  const TopStores({
    Key? key,
    required this.stores,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no data
    if (stores.isEmpty) {
      if (!isLoading) {
        // Not loading => no data
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: Center(child: Text('No stores found')),
          ),
        );
      }
      // If loading => show 4 placeholders
      return _buildPlaceholderRows();
    }

    // If we have data
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // First row
              Row(
                children: List.generate(
                  (stores.length / 2).ceil(),
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _StoreCard(
                      store: stores[index],
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Second row
              Row(
                children: List.generate(
                  (stores.length / 2).floor(),
                  (idx) {
                    final adjustedIndex = idx + (stores.length / 2).ceil();
                    if (adjustedIndex >= stores.length) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _StoreCard(
                        store: stores[adjustedIndex],
                        isLoading: isLoading,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 4 placeholders => 2 items in first row, 2 items in second row
  Widget _buildPlaceholderRows() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // First row (2 placeholders)
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: _StorePlaceholderCard(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Second row (2 placeholders)
              Row(
                children: List.generate(2, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: _StorePlaceholderCard(),
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

// The real store card
class _StoreCard extends StatelessWidget {
  final StoreEntity store;
  final bool isLoading;

  const _StoreCard({
    Key? key,
    required this.store,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        children: [
          // Image Card
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: AppColors.tertiaryText,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                store.imageUrl,
                fit: BoxFit.fill,
                height: 80, // Set a fixed height
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          // Text under the image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              store.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            "Up to 10% Cashback",
            style: TextStyle(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

// A placeholder card (while loading, no data yet)
class _StorePlaceholderCard extends StatelessWidget {
  const _StorePlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.tertiaryText,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 16,
            color: AppColors.tertiaryText,
          ),
          const SizedBox(height: 4),
          Container(
            width: 80,
            height: 16,
            color: AppColors.tertiaryText,
          ),
        ],
      ),
    );
  }
}
