part of 'store_details_cubit.dart';

@immutable
abstract class StoreDetailsState {}

/// Initial state (before any store detail is requested)
class StoreDetailsInitial extends StoreDetailsState {}

/// Loading state while retrieving a store by ID
class StoreDetailsLoading extends StoreDetailsState {}

/// Success state that holds the fully fetched [StoreEntity] data
class StoreDetailsSuccess extends StoreDetailsState {
  final StoreEntity store;

  StoreDetailsSuccess(this.store);
}

/// Failure state with an error [message]
class StoreDetailsFailure extends StoreDetailsState {
  final String message;

  StoreDetailsFailure({required this.message});
}
