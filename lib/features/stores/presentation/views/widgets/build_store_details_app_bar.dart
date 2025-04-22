import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

AppBar buildStoreDetailsAppBar(StoreDetailsState state) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: state is StoreDetailsSuccess
        ? Text(
            state.store.title,
            style: AppTextStyles.bold18,
          )
        : const Text('Unknown Store'),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(
          FontAwesomeIcons.bookmark,
          size: 24,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.share_outlined,
          size: 24,
        ),
      ),
      const SizedBox(width: 16),
    ],
  );
}
