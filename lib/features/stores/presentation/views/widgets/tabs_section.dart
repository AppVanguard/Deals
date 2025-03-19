import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/presentation/views/widgets/about_tab.dart';
import 'package:deals/features/stores/presentation/views/widgets/cash_back_tab.dart';
import 'package:deals/features/stores/presentation/views/widgets/coupons_tab.dart';
import 'package:flutter/material.dart';

class TabsSection extends StatefulWidget {
  const TabsSection({super.key, this.store, this.coupons});
  final StoreEntity? store;
  final List<CouponEntity>? coupons;
  @override
  State<TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<TabsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define the tabs you want to show.
  final List<Tab> _tabs = const [
    Tab(text: "Cashback"),
    Tab(text: "Coupons"),
    Tab(text: "About"),
  ];

  @override
  void initState() {
    super.initState();
    // Create a TabController for 3 tabs.
    _tabController = TabController(length: _tabs.length, vsync: this);

    // Rebuild whenever the user taps a different tab.
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // A helper method to show the correct content for each tab.
  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return CashbackTab(
          storeEntity: widget.store,
        );
      case 1:
        return Expanded(
          child: CouponsTab(
            coupons: widget.coupons,
            storeEntity: widget.store,
          ),
        );
      case 2:
        return AboutTab(
          storeEntity: widget.store,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The actual TabBar
        TabBar(
          dividerHeight: 0,
          controller: _tabController,
          // Customize how the tabs look:
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs,
        ),
        const SizedBox(height: 16),

        // Instead of TabBarView, we manually show content below.
        // This avoids the unbounded-height error inside SingleChildScrollView.
        _buildTabContent(_tabController.index),
        const SizedBox(height: 24),
      ],
    );
  }
}
