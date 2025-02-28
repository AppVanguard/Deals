// home_state.dart (part of 'home_cubit.dart')
part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  final HomeStatus status;
  final HomeEntity? homeEntity;
  final String? errorMessage;

  const HomeState({
    required this.status,
    this.homeEntity,
    this.errorMessage,
  });

  factory HomeState.initial() {
    return const HomeState(
      status: HomeStatus.initial,
      homeEntity: null,
      errorMessage: null,
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    HomeEntity? homeEntity,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeEntity: homeEntity ?? this.homeEntity,
      errorMessage: errorMessage,
    );
  }
}
