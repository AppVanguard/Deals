import 'dart:developer';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:deals/features/stores/presentation/views/widgets/build_store_details_app_bar.dart';
import 'package:deals/features/stores/presentation/views/widgets/tabs_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ... other imports

class StoreDetailView extends StatelessWidget {
  const StoreDetailView({super.key, required this.storeId});
  final String storeId;
  static const routeName = '/store-detail';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailsState>(
      builder: (context, state) {
        log("The state is: $state");
        if (state is StoreDetailsInitial) {
          context.read<StoreDetailCubit>().getStoreAndCoupons(storeId);
        }
        if (state is StoreDetailsFailure) {
          return buildCustomErrorScreen(
            context: context,
            onRetry: () {
              context.read<StoreDetailCubit>().getStoreAndCoupons(storeId);
            },
          );
        }
        var storeDetails = state is StoreDetailsSuccess ? state.store : null;
        return Skeletonizer(
          enabled: state is StoreDetailsLoading || state is StoreDetailsInitial,
          child: Scaffold(
            appBar: buildStoreDetailsAppBar(state),
            body: Skeletonizer(
              enabled:
                  state is StoreDetailsLoading || state is StoreDetailsInitial,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // 1) Big store image
                      AspectRatio(
                        aspectRatio: 1.4,
                        child: Image.asset(
                          AppImages.assetsImagesTest1,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2) Below the image, show the tab bar + content
                      TabsSection(
                        store: storeDetails,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
