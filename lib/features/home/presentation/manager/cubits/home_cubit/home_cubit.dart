import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';

import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
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
      log('[HomeCubit] Manual refresh requested → clearing cache');
      emit(HomeLoading());
      await DefaultCacheManager().emptyCache();
    }

    // 1) — Try cached data
    final Either<Failure, HomeEntity> cacheResult =
        await homeRepo.getCachedData();

    cacheResult.fold(
      (_) {
        log('[HomeCubit] No cached data available');
        if (!isRefresh) emit(HomeLoading());
      },
      (cachedEntity) {
        log('[HomeCubit] Cached data found → emitting immediately');
        if (!isRefresh) emit(HomeSuccess(homeEntity: cachedEntity));
      },
    );

    // 2) — Always call backend
    log('[HomeCubit] Fetching fresh data from backend');
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
        log('[HomeCubit] Remote fetch FAILED → ${failure.message}');
        // If nothing visible yet, surface the error
        if (state is HomeInitial || state is HomeLoading) {
          emit(HomeFailure(errorMessage: failure.message));
        }
      },
      (freshEntity) {
        log('[HomeCubit] Remote fetch SUCCESS → emitting fresh data');
        emit(HomeSuccess(homeEntity: freshEntity));
      },
    );
  }
}
