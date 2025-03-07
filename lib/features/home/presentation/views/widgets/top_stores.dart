import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopStores extends StatefulWidget {
  final List<StoreEntity> stores;
  final bool isLoading;

  const TopStores({
    super.key,
    required this.stores,
    required this.isLoading,
  });

  @override
  State<TopStores> createState() => _TopStoresState();
}

class _TopStoresState extends State<TopStores> {
  // We store a local copy of isLoading so we can trigger setState
  bool localIsLoading = false;

  @override
  void initState() {
    super.initState();
    localIsLoading = widget.isLoading;
  }

  // If parent changes isLoading from false to true (or vice versa),
  // we call setState so the skeleton or real data is updated
  @override
  void didUpdateWidget(covariant TopStores oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      setState(() {
        localIsLoading = widget.isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no data
    if (widget.stores.isEmpty && !localIsLoading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(child: Text('No stores found')),
        ),
      );
    }

    // If we have data or we are in loading mode
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Column(
                children: [
                  // First row
                  Row(
                    children: List.generate(
                      localIsLoading ? 6 : (widget.stores.length / 2).ceil(),
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: _StoreCard(
                          store: localIsLoading
                              ? StoreEntity(
                                  category: null,
                                  id: '',
                                  title: '',
                                  storeUrl: '',
                                  isActive: false,
                                )
                              : widget.stores[index],
                          isLoading: localIsLoading,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Second row
                  Row(
                    children: List.generate(
                      localIsLoading ? 6 : (widget.stores.length / 2).floor(),
                      (idx) {
                        final adjustedIndex =
                            idx + (widget.stores.length / 2).ceil();
                        if (!localIsLoading &&
                            adjustedIndex >= widget.stores.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _StoreCard(
                            store: localIsLoading
                                ? StoreEntity(
                                    category: null,
                                    id: '',
                                    title: '',
                                    storeUrl: '',
                                    isActive: false,
                                  )
                                : widget.stores[adjustedIndex],
                            isLoading: localIsLoading,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
  final bool isLoading;

  const _StoreCard({
    required this.store,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.tertiaryText,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                store.imageUrl ?? '',
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(AppImages.assetsImagesTest1, fit: BoxFit.fill),
              ),
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
