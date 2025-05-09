import 'dart:developer';
import 'package:deals/features/bookmarks/presentation/manager/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:deals/core/widgets/generic_card.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';

class BookmarkViewBody extends StatefulWidget {
  const BookmarkViewBody({super.key});

  @override
  State<BookmarkViewBody> createState() => _BookmarkViewBodyState();
}

class _BookmarkViewBodyState extends State<BookmarkViewBody> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<BookmarkCubit>();
    final st = cubit.state;
    if (st is BookmarkSuccess &&
        !st.isLoadingMore &&
        st.pagination.currentPage < st.pagination.totalPages &&
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      log('Scroll → load next bookmarks page');
      cubit.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (_, state) {
        if (state is BookmarkLoading) {
          return _buildSkeletonList();
        }
        if (state is BookmarkFailure) {
          return buildCustomErrorScreen(
            context: context,
            onRetry: () =>
                context.read<BookmarkCubit>().loadBookmarks(isRefresh: true),
          );
        }
        if (state is BookmarkSuccess) {
          return _buildBookmarksList(
            context,
            state.bookmarks,
            isLoadingMore: state.isLoadingMore ||
                (state.pagination.currentPage < state.pagination.totalPages),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  //──────────────────────────────────────── helpers

  Widget _buildSkeletonList() => ListView.builder(
        controller: _scroll,
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Skeletonizer(
            enabled: true,
            child: GenericCard(
              title: 'loading',
              subtitle: 'loading',
              imagePath: '',
            ),
          ),
        ),
      );

  Widget _buildBookmarksList(
    BuildContext context,
    List<BookmarkEntity> list, {
    required bool isLoadingMore,
  }) =>
      ListView.builder(
        controller: _scroll,
        itemCount: list.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i < list.length) {
            final b = list[i];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _cardFromBookmark(context, b),
            );
          }
          // bottom skeleton while loading next page
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Skeletonizer(
              enabled: true,
              child: GenericCard(
                title: 'loading',
                subtitle: 'loading',
                imagePath: '',
              ),
            ),
          );
        },
      );

  Widget _cardFromBookmark(BuildContext context, BookmarkEntity b) {
    final l10n = S.of(context);
    final hasCashback = (b.storeCashbackRate ?? 0) != 0;
    final hasCoupons = (b.storeTotalCoupons ?? 0) != 0;

    String subtitle;
    if (hasCashback && hasCoupons) {
      subtitle =
          "${l10n.upTo} ${b.storeCashbackRate}% ${l10n.CashbackC} + ${b.storeTotalCoupons} ${l10n.Coupons}";
    } else if (hasCashback) {
      subtitle = "${l10n.upTo} ${b.storeCashbackRate}% ${l10n.CashbackC}";
    } else if (hasCoupons) {
      subtitle = "${b.storeTotalCoupons} ${l10n.Coupons}";
    } else {
      subtitle = l10n.noOffers; // add to your ARB
    }

    return GenericCard(
      imagePath: b.storeImageUrl ?? '',
      title: b.storeTitle ?? '',
      subtitle: subtitle,
      onTap: () => context.pushNamed(
        StoreDetailView.routeName,
        extra: b.storeId,
      ),
    );
  }
}
