// lib/features/home/presentation/views/widgets/build_home_app_bar.dart

import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/notifications_view.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';

AppBar buildHomeAppBar({
  required BuildContext context,
  required UserEntity userData,
}) {
  return AppBar(
    bottom: const PreferredSize(
      preferredSize: Size(0, 1),
      child: Divider(),
    ),
    elevation: 0,
    backgroundColor: AppColors.background,
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.primary,
            size: 32,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      },
    ),
    title: Row(
      spacing: 16,
      children: [
        Text(
          appTittle,
          style: AppTextStyles.bold24.copyWith(color: AppColors.primary),
        ),
        const Spacer(),
        SvgPicture.asset(AppImages.assetsImagesRefer),
        GestureDetector(
          child: SvgPicture.asset(AppImages.assetsImagesSearch),
          onTap: () {
            context.pushNamed(SearchView.routeName);
          },
        ),
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            bool hasUnread = false;
            if (state is NotificationsSuccess) {
              hasUnread = state.notifications.any((n) => !n.read);
            }
            return GestureDetector(
              onTap: () {
                context.pushNamed(
                  NotificationsView.routeName,
                  extra: {
                    'userId': userData.uId,
                    'token': userData.token,
                  },
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      top: -4,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
