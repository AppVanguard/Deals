import 'package:deals/features/categories/presentation/views/widgets/build_category_app_bar.dart';
import 'package:deals/features/categories/presentation/views/widgets/categories_view_body.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});
  static const routeName = 'categories';

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCategoryAppBar(context, searchController),
      body: CategoriesViewBody(),
    );
  }
}
