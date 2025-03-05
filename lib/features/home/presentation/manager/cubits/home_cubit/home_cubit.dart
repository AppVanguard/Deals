import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/home/domain/entities/home_entity.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeState.initial()) {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    // 1) Try reading cached data
    final Either<Failure, HomeEntity> cacheResult =
        await homeRepo.getCachedData();

    cacheResult.fold(
      (failure) {
        // If no cache, show "loading" while we fetch remote
        emit(state.copyWith(status: HomeStatus.loading));
      },
      (cachedEntity) {
        // If we have cached data, show it immediately
        emit(state.copyWith(
          status: HomeStatus.success,
          homeEntity: cachedEntity,
        ));
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
        // If remote fails, remain in the current state (we still have cached data if it existed).
        // But if there was no cache to begin with, we must show error:
        if (state.homeEntity == null) {
          emit(state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ));
        }
        // Optionally you can show a toast or leave it as is
      },
      (freshEntity) {
        // Overwrite with new data
        emit(state.copyWith(
          status: HomeStatus.success,
          homeEntity: freshEntity,
        ));
      },
    );
  }
}
