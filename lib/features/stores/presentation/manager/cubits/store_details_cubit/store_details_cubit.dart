import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:meta/meta.dart';

part 'store_details_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailsState> {
  final StoresRepo storesRepo;

  StoreDetailCubit({required this.storesRepo}) : super(StoreDetailsInitial());

  /// Fetch a single store by [storeId].
  /// Emits [StoreDetailLoading], then [StoreDetailSuccess] or [StoreDetailFailure].
  Future<void> getStoreById(String storeId) async {
    emit(StoreDetailsLoading());
    final result = await storesRepo.getStoreById(storeId);
    result.fold(
      (failure) => emit(StoreDetailsFailure(message: failure.message)),
      (storeEntity) => emit(StoreDetailsSuccess(storeEntity)),
    );
  }
}
