import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';
import 'package:deals/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/home/presentation/views/home_view.dart';
import 'package:deals/features/stores/presentation/views/stores_view.dart';
import 'package:deals/features/coupons/presentation/views/coupon_view.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/main/presentation/views/widgets/custom_bottom_navigation_bar.dart';

class MainView extends StatefulWidget {
  final UserEntity userData;
  const MainView({super.key, required this.userData});
  static const routeName = '/main';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Immediately fetch notifications in MainView so that the Home AppBar can update.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = widget.userData.token;
      if (token.isNotEmpty) {
        context.read<NotificationsCubit>().fetchNotifications(token);
      }
    });

    _pages = [
      KeyedSubtree(
        key: const ValueKey('Home'),
        child: BlocProvider(
          create: (_) => HomeCubit(
            homeRepo: getIt<HomeRepo>(),
            jwt: widget.userData.token, // <– inject the user’s JWT once
          ),
          child: HomeView(userData: widget.userData),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('Stores'),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => StoresCubit(storesRepo: getIt<StoresRepo>()),
            ),
            BlocProvider(
              create: (_) => CategoriesCubit(
                categoriesRepo: getIt<CategoriesRepo>(),
              ),
            )
          ],
          child: const StoresView(),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('Coupons'),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CouponsCubit(
                couponsRepo: getIt<CouponsRepo>(),
              ),
            ),
            BlocProvider(
              create: (_) => CategoriesCubit(
                categoriesRepo: getIt<CategoriesRepo>(),
              ),
            )
          ],
          child: const CouponView(),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
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
