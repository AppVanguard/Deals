// home_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeState.initial());

  /// Fetch home data with pagination
  Future<void> fetchHomeData({
    required int announcementsPage,
    required int announcementsCount,
    required int storesPage,
    required int storesCount,
    required int couponsPage,
    required int couponsCount,
  }) async {
    // Emit a loading state
    emit(state.copyWith(status: HomeStatus.loading));

    // Call the repository (which calls the service)
    final eitherOrFailure = await homeRepo.getHomeData(
      announcementsPage: announcementsPage,
      announcementsCount: announcementsCount,
      storesPage: storesPage,
      storesCount: storesCount,
      couponsPage: couponsPage,
      couponsCount: couponsCount,
    );

    eitherOrFailure.fold(
      // On failure, emit the error state with message
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      // On success, emit the success state with data
      (homeData) => emit(
        state.copyWith(
          status: HomeStatus.success,
          homeEntity: homeData,
        ),
      ),
    );
  }

  /// Optionally, map different Failure types to user-friendly messages
  String _mapFailureToMessage(Failure failure) {
    return failure.message; // or do more logic if needed
  }
}
