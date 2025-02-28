// home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeState.initial()) {
    // Optionally trigger fetch on creation
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final Either<Failure, HomeEntity> eitherOrFailure =
        await homeRepo.getHomeData(
      announcementsPage: 1,
      announcementsCount: 4,
      storesPage: 1,
      storesCount: 10,
      couponsPage: 1,
      couponsCount: 10,
    );

    eitherOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (homeEntity) => emit(
        state.copyWith(
          status: HomeStatus.success,
          homeEntity: homeEntity,
        ),
      ),
    );
  }
}
