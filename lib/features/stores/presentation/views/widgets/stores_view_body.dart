import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/widgets/generic_card.dart';

class StoresViewBody extends StatefulWidget {
  const StoresViewBody({Key? key}) : super(key: key);

  @override
  State<StoresViewBody> createState() => _StoresViewBodyState();
}

class _StoresViewBodyState extends State<StoresViewBody> {
  final ScrollController _scrollController = ScrollController();
  final List<String> tabs = [
    'All',
    'New stores',
    'Marketplace',
    'Fashion',
    'Food&Drink',
    'Travel',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<StoresCubit>();
      final currentState = cubit.state;
      if (currentState is StoresSuccess && currentState.hasMore) {
        cubit.fetchStores(isRefresh: false);
      }
    }
  }

  Widget _buildStoreCard(StoreEntity store) {
    return GenericCard(
      imagePath: store.imageUrl ?? '',
      title: store.title,
      subtitle:
          'Coupons: ${store.totalCoupons ?? 0} • Savings: ${store.averageSavings ?? 0}',
      onTap: () {
        // Handle tap (e.g., navigate to store details).
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          // TabBar for categories.
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
          // TabBarView showing the same store list in each tab.
          Expanded(
            child: TabBarView(
              children: tabs.map((_) {
                return BlocBuilder<StoresCubit, StoresState>(
                  builder: (context, state) {
                    if (state is StoresLoading && state is! StoresSuccess) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StoresFailure) {
                      return Center(child: Text(state.message));
                    } else if (state is StoresSuccess) {
                      final stores = state.stores;
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: stores.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < stores.length) {
                            return _buildStoreCard(stores[index]);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      );
                    }
                    return const SizedBox.shrink();
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
