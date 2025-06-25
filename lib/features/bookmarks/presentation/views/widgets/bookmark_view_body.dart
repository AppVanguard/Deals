// lib/features/bookmarks/presentation/views/widgets/bookmark_view_body.dart
import 'package:deals/core/utils/dev_log.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';

import 'package:deals/generated/l10n.dart';
import 'package:deals/core/widgets/generic_card.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/presentation/manager/cubits/bookmark_cubit/bookmark_cubit.dart';

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

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  /*────────── infinite‑scroll ──────────*/
  void _onScroll() {
    final cubit = context.read<BookmarkCubit>();
    final st = cubit.state;
    if (st is BookmarkSuccess &&
        !st.isLoadingMore &&
        st.pagination.currentPage < st.pagination.totalPages &&
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      log('[BookmarkViewBody] scroll → loadNextPage');
      cubit.loadNextPage();
    }
  }

  /*────────── pull‑to‑refresh ──────────*/
  Future<void> _refresh() =>
      context.read<BookmarkCubit>().loadBookmarks(isRefresh: true);

  /*──────────── UI ────────────*/
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (_, state) {
          if (state is BookmarkLoading) return _skeletonList();
          if (state is BookmarkFailure) {
            if (state.message.contains('Invalid token')) {
              return const SizedBox.shrink();
            }
            return buildCustomErrorScreen(
              context: context,
              onRetry: _refresh,
              errorMessage: state.message,
            );
          }
          if (state is BookmarkSuccess) {
            final more = state.isLoadingMore ||
                (state.pagination.currentPage < state.pagination.totalPages);
            return _bookmarksList(context, state.bookmarks,
                isLoadingMore: more);
          }
          // default empty scrollable so RefreshIndicator can activate
          return ListView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
          );
        },
      ),
    );
  }

  /*──────── list builders ────────*/

  Widget _skeletonList() => ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
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

  Widget _bookmarksList(
    BuildContext ctx,
    List<BookmarkEntity> list, {
    required bool isLoadingMore,
  }) =>
      ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i < list.length) {
            final b = list[i];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _cardFromBookmark(ctx, b),
            );
          }
          // bottom skeleton while next page is loading
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

  /*──────── card helper ─────────*/

  Widget _cardFromBookmark(BuildContext context, BookmarkEntity b) {
    final l10n = S.of(context);
    final hasCashback = (b.storeCashbackRate ?? 0) != 0;
    final hasCoupons = (b.storeTotalCoupons ?? 0) != 0;

    String subtitle;
    if (hasCashback && hasCoupons) {
      subtitle = '${l10n.upTo} ${b.storeCashbackRate}% ${l10n.CashbackC} + '
          '${b.storeTotalCoupons} ${l10n.Coupons}';
    } else if (hasCashback) {
      subtitle = '${l10n.upTo} ${b.storeCashbackRate}% ${l10n.CashbackC}';
    } else if (hasCoupons) {
      subtitle = '${b.storeTotalCoupons} ${l10n.Coupons}';
    } else {
      subtitle = l10n.noOffers;
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
