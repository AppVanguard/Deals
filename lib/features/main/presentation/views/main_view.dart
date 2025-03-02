import 'package:flutter/material.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:deals/features/home/presentation/views/home_view.dart';
import 'package:deals/features/categories/presentation/views/categories_view.dart';
// import other pages like CouponsView, BookmarksView, etc.

class MainView extends StatefulWidget {
  final UserEntity userData;
  const MainView({super.key, required this.userData});
  static const routeName = 'main';
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  // Create a list of "pages". Each is a full widget with its own Scaffold.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize your pages here, each receiving userData if needed
    _pages = [
      HomeView(userData: widget.userData),
      CategoriesView(),
      // Example placeholders for your other tabs:
      // CouponsView(userData: widget.userData),
      // BookmarksView(userData: widget.userData),
      Container(
        color: Colors.blueGrey,
        child: const Center(child: Text('Coupons Page Placeholder')),
      ),
      Container(
        color: Colors.greenAccent,
        child: const Center(child: Text('Bookmarks Page Placeholder')),
      ),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Parent scaffold has NO appBar. Only the bottom navigation bar.
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
      // Use IndexedStack to keep the state of each page alive when switching tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
