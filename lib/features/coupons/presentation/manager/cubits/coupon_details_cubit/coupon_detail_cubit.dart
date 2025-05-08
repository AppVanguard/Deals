import 'package:deals/core/service/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:meta/meta.dart';

part 'coupon_detail_state.dart';

class CouponDetailCubit extends Cubit<CouponDetailState> {
  final CouponsRepo couponsRepo;
  CouponDetailCubit({required this.couponsRepo}) : super(CouponDetailInitial());

  /// Fetches the coupon details by its [id]
  Future<void> getCouponById(String id) async {
    emit(CouponDetailLoading());
    final user = await SecureStorageService.getCurrentUser();

    final result = await couponsRepo.getCouponById(id, user!.token);
    result.fold(
      (failure) => emit(CouponDetailFailure(message: failure.message)),
      (coupon) => emit(CouponDetailSuccess(coupon: coupon)),
    );
  }
}
