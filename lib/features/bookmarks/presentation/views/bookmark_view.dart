import 'dart:async';
import 'package:deals/features/bookmarks/presentation/manager/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/search/presentation/manager/search_cubit/search_cubit.dart';

import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/features/bookmarks/presentation/views/widgets/bookmark_view_body.dart';
import 'package:deals/features/bookmarks/presentation/views/widgets/build_bookmark_app_bar.dart';

class BookmarkView extends StatefulWidget {
  const BookmarkView({super.key, required this.user});
  static const routeName = '/bookmarks';
  final UserEntity user;

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  /* local filter state */
  List<String> _selectedCats = [];
  String _sortOrder = 'asc';
  bool _hasCoupons = false;
  bool _hasCashback = false;

  @override
  void initState() {
    super.initState();

    /// 🔹 Kick-off category loading as soon as this page is inserted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().fetchCategories(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  /* ────────────────────────── Callbacks ───────────────────────── */

  void _onSearchChanged(String q) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    context.read<SearchCubit>().updateQuery(q);
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<BookmarkCubit>().updateFilters(
            search: context.read<SearchCubit>().state.query,
            categories: _selectedCats,
            hasCoupons: _hasCoupons,
            hasCashback: _hasCashback,
            sortOrder: _sortOrder,
          );
    });
  }

  void _onFilterChanged(
    List<String> cats,
    String order,
    bool coupons,
    bool cashback,
  ) {
    setState(() {
      _selectedCats = cats;
      _sortOrder = order;
      _hasCoupons = coupons;
      _hasCashback = cashback;
    });

    context.read<BookmarkCubit>().updateFilters(
          search: context.read<SearchCubit>().state.query,
          categories: _selectedCats,
          hasCoupons: _hasCoupons,
          hasCashback: _hasCashback,
          sortOrder: _sortOrder,
        );
  }

  /* ───────────────────────────── UI ───────────────────────────── */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBookmarkAppBar(
        context,
        _searchCtrl,
        onSearch: _onSearchChanged,
        onFilterChanged: _onFilterChanged,
        selectedCats: _selectedCats,
        sortOrder: _sortOrder,
        hasCoupons: _hasCoupons,
        hasCashback: _hasCashback,
      ),
      body: const BookmarkViewBody(),
    );
  }
}
