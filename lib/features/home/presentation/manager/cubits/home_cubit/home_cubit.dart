import 'package:deals/core/utils/logger.dart';

import 'package:dartz/dartz.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';

import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends SafeCubit<HomeState> {
  HomeCubit({
    required this.homeRepo,
    required this.jwt,
  }) : super(HomeInitial()) {
    _fetchHomeData(isRefresh: false);
  }

  // ─── Dependencies ────────────────────────────────────────────────────────
  final HomeRepo homeRepo;
  final String jwt;

  // ─── Public API ──────────────────────────────────────────────────────────
  /// Call from the UI’s `RefreshIndicator` to force a network refresh.
  Future<void> refresh() => _fetchHomeData(isRefresh: true);

  // ─── Internal orchestration ──────────────────────────────────────────────
  Future<void> _fetchHomeData({required bool isRefresh}) async {
    if (isRefresh) {
      appLog('[HomeCubit] Manual refresh requested → clearing cache');
      emit(HomeLoading());
      await DefaultCacheManager().emptyCache();
    }

    // 1) — Try cached data
    final Either<Failure, HomeEntity> cacheResult =
        await homeRepo.getCachedData();

    cacheResult.fold(
      (_) {
        appLog('[HomeCubit] No cached data available');
        if (!isRefresh) emit(HomeLoading());
      },
      (cachedEntity) {
        appLog('[HomeCubit] Cached data found → emitting immediately');
        if (!isRefresh) emit(HomeSuccess(homeEntity: cachedEntity));
      },
    );

    // 2) — Always call backend
    appLog('[HomeCubit] Fetching fresh data from backend');
    final Either<Failure, HomeEntity> remoteResult =
        await homeRepo.getFreshData(
      token: jwt,
      announcementsPage: 1,
      announcementsCount: 4,
      storesPage: 1,
      storesCount: 10,
      couponsPage: 1,
      couponsCount: 10,
    );

    remoteResult.fold(
      (failure) {
        appLog('[HomeCubit] Remote fetch FAILED → ${failure.message}');
        // If nothing visible yet, surface the error
        if (state is HomeInitial || state is HomeLoading) {
          emit(HomeFailure(errorMessage: failure.message));
        }
      },
      (freshEntity) {
        appLog('[HomeCubit] Remote fetch SUCCESS → emitting fresh data');
        emit(HomeSuccess(homeEntity: freshEntity));
      },
    );
  }
}
