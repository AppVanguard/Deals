import 'package:deals/features/bookmarks/presentation/manager/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';

AppBar buildStoreDetailsAppBar(BuildContext context, StoreDetailsState state) {
  final bookmarkCubit = context.watch<BookmarkCubit>();

  final storeId = state is StoreDetailsSuccess ? state.store.id : null;
  final isSaved = storeId != null && bookmarkCubit.isBookmarked(storeId);

  return AppBar(
    elevation: 0,
    backgroundColor: AppColors.background,
    centerTitle: true,
    title: state is StoreDetailsSuccess
        ? Text(state.store.title, style: AppTextStyles.bold18)
        : const Text('Unknown Store'),
    actions: [
      IconButton(
        icon: Icon(
          FontAwesomeIcons.bookmark,
          size: 24,
          color: isSaved ? AppColors.primary : null,
        ),
        onPressed: storeId == null
            ? null
            : () => bookmarkCubit.toggleBookmark(storeId),
      ),
      IconButton(
        icon: const Icon(Icons.share_outlined, size: 24),
        onPressed: () {}, // implement share later
      ),
      const SizedBox(width: 16),
    ],
  );
}
