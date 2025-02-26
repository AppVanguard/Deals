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

  /// Initial state
  factory HomeState.initial() {
    return const HomeState(
      status: HomeStatus.initial,
      homeEntity: null,
      errorMessage: null,
    );
  }

  /// Helper to create new copies of the state
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

  @override
  List<Object?> get props => [status, homeEntity, errorMessage];
}
