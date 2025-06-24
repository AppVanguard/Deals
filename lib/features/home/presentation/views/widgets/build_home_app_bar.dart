import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/coming_soon_toast.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/notifications_view.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';

/// Builds the Home AppBar with uniform icon sizing and a correctly-sized refer pill.
AppBar buildHomeAppBar({
  required BuildContext context,
  required UserEntity userData,
}) {
  final s = S.of(context);

  // fixed, uniform sizes
  const double iconSize = 28.0;
  const double titleFontSize = 22.0;
  const double gap = 12.0;

  return AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    automaticallyImplyLeading: false,
    titleSpacing: 0,

    // ───── MENU BUTTON ─────
    leading: Builder(
      builder: (ctx) => IconButton(
        iconSize: iconSize,
        icon: const Icon(Icons.menu, color: AppColors.primary),
        onPressed: () => Scaffold.of(ctx).openDrawer(),
      ),
    ),

    // ───── TITLE + ICONS ─────
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: gap),
      child: Row(
        children: [
          // Title
          Text(
            appTitle,
            style: AppTextStyles.bold24.copyWith(
              fontSize: titleFontSize,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),

          // ───── REFER PILL ─────
          GestureDetector(
              onTap: () => showComingSoonToast(context, s.refer),
              child: SvgPicture.asset(
                AppImages.assetsImagesRefer,
                // width: iconSize ,     // ~21dp
                // height: iconSize ,
              )),
          const SizedBox(width: gap),

          // ───── SEARCH ─────
          GestureDetector(
            onTap: () => context.pushNamed(SearchView.routeName),
            child: SvgPicture.asset(
              AppImages.assetsImagesSearch,
              // width: iconSize,
              // height: iconSize,
            ),
          ),
          const SizedBox(width: gap),

          // ───── NOTIFICATIONS + BADGE ─────
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (ctx, state) {
              final hasUnread = state is NotificationsSuccess
                  ? state.notifications.any((n) => !n.read)
                  : false;

              return GestureDetector(
                onTap: () => context.pushNamed(
                  NotificationsView.routeName,
                  extra: {
                    kUserId: userData.uId,
                    kToken: userData.token,
                  },
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_none_outlined,
                      size: iconSize,
                      color: AppColors.primary,
                    ),
                    if (hasUnread)
                      Positioned(
                        right: -2,
                        top: -4,
                        child: Container(
                          width: iconSize * 0.35,
                          height: iconSize * 0.35,
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

          const SizedBox(width: gap),
        ],
      ),
    ),

    // ───── DIVIDER ─────
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1),
    ),
  );
}
