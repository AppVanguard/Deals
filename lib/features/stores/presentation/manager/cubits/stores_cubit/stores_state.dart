part of 'stores_cubit.dart';

@immutable
abstract class StoresState {}

class StoresInitial extends StoresState {}

class StoresLoading extends StoresState {}

class StoresSuccess extends StoresState {
  final List<StoreEntity> stores;
  final int currentPage;
  final bool hasMore;

  StoresSuccess({
    required this.stores,
    required this.currentPage,
    required this.hasMore,
  });
}

class StoresFailure extends StoresState {
  final String message;

  StoresFailure({required this.message});
}
