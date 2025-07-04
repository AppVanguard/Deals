import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart'; // <-- new

/// Horizontal list of the most popular stores.

class TopStores extends StatefulWidget {
  /// Store items to display.
  final List<StoreEntity> stores;

  /// Whether to show skeleton placeholders.
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
                              ? const StoreEntity(
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
                                ? const StoreEntity(
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
          GestureDetector(
            onTap: () {
              context.pushNamed(
                StoreDetailView.routeName,
                extra: store.id,
              );
            },
            child: Container(
              width: 150,
              height: 90,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withValues(alpha: 0.5),
                    blurRadius: 2,
                  ),
                ],
                color: AppColors.tertiaryText,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: store.imageUrl ?? '',
                  width: 150,
                  height: 90,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Skeletonizer(
                    child: Container(
                      width: 150,
                      height: 90,
                      color: AppColors.lightGray,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppImages.assetsImagesTest3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "${S.of(context).upTo} ${store.cashBackRate}% ${S.of(context).cashBack}",
            style: const TextStyle(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
