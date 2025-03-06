import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeInitial()) {
    // Automatically fetch data on creation
    fetchHomeData();
  }

  /// Fetch fresh data, optionally indicating if it's a full "refresh".
  Future<void> fetchHomeData({bool isRefresh = false}) async {
    // If user explicitly refreshes, show loading to display a spinner at the top
    if (isRefresh) {
      emit(HomeLoading());
    }

    // 1) Try reading cached data
    final Either<Failure, HomeEntity> cacheResult =
        await homeRepo.getCachedData();

    cacheResult.fold(
      (failure) {
        // If there's no cache, remain in or switch to loading while fetching remote
        if (!isRefresh) {
          emit(HomeLoading());
        }
      },
      (cachedEntity) {
        // If we have cached data and it's not a forced refresh, show it immediately
        if (!isRefresh) {
          emit(HomeSuccess(homeEntity: cachedEntity));
        }
      },
    );

    // 2) Regardless of cache, fetch from remote in the background
    final Either<Failure, HomeEntity> remoteResult =
        await homeRepo.getFreshData(
      announcementsPage: 1,
      announcementsCount: 4,
      storesPage: 1,
      storesCount: 10,
      couponsPage: 1,
      couponsCount: 10,
    );

    remoteResult.fold(
      (failure) {
        // If remote fails and we had no data before, show error
        if (state is HomeInitial || state is HomeLoading) {
          emit(HomeFailure(errorMessage: failure.message));
        }
        // If we were showing cached data, you can keep the old data or handle partial updates
      },
      (freshEntity) {
        // Overwrite with new data
        emit(HomeSuccess(homeEntity: freshEntity));
      },
    );
  }
}
