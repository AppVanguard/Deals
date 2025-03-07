import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/main/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:deals/features/home/presentation/views/home_view.dart';
import 'package:deals/features/stores/presentation/views/stores_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatefulWidget {
  final UserEntity userData;
  const MainView({super.key, required this.userData});
  static const routeName = 'main';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  int _previousIndex = 0; // Track the previous index to decide slide direction

  // Wrap each page in a KeyedSubtree so AnimatedSwitcher can properly distinguish them.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      KeyedSubtree(
        key: const ValueKey('Home'),
        child: HomeView(userData: widget.userData),
      ),
      KeyedSubtree(
        key: const ValueKey('Categories'),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => StoresCubit(
                storesRepo: getIt<StoresRepo>(),
              ),
            ),
            BlocProvider(
              create: (context) => CategoriesCubit(
                categoriesRepo: getIt<CategoriesRepo>(),
              ),
            ),
          ],
          child: const StoresView(),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('Coupons'),
        child: Container(
          color: Colors.blueGrey,
          child: const Center(child: Text('Coupons Page Placeholder')),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('Bookmarks'),
        child: Container(
          color: Colors.greenAccent,
          child: const Center(child: Text('Bookmarks Page Placeholder')),
        ),
      ),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottom navigation bar remains fixed.
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
      // AnimatedSwitcher handles the slide transition between pages.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          // Determine slide direction:
          // If moving forward (_selectedIndex > _previousIndex) slide from right,
          // otherwise slide from left.
          final beginOffset = _selectedIndex > _previousIndex
              ? const Offset(1, 0)
              : const Offset(-1, 0);
          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _pages[_selectedIndex],
      ),
    );
  }
}
