import 'package:deals/constants.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:deals/features/auth/presentation/views/forget_password_view.dart';
import 'package:deals/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/personal_data_view.dart';
import 'package:deals/features/auth/presentation/views/reset_password_view.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/auth/presentation/views/signup_view.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupon_details_cubit/coupon_detail_cubit.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:deals/features/coupons/presentation/views/coupon_details_view.dart';
import 'package:deals/features/coupons/presentation/views/coupon_view.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/notifications_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';
import 'package:deals/features/splash/presentation/views/splash_view.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:deals/features/stores/presentation/views/stores_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: SplashView.routeName,
    routes: [
      // Splash Route
      GoRoute(
        path: SplashView.routeName,
        name: SplashView.routeName,
        builder: (context, state) => const SplashView(),
      ),
      // OnBoarding Route
      GoRoute(
        path: OnBoardingView.routeName,
        name: OnBoardingView.routeName,
        builder: (context, state) => const OnBoardingView(),
      ),
      // Signin Route
      GoRoute(
        path: SigninView.routeName,
        name: SigninView.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => SigninCubit(
              getIt.get<AuthRepo>(),
              getIt.get<NotificationsPermissionRepo>(),
            ),
            child: const SigninView(),
          );
        },
      ),
      // Signup Route
      GoRoute(
        path: SignupView.routeName,
        name: SignupView.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => SignupCubit(getIt.get<AuthRepo>()),
            child: const SignupView(),
          );
        },
      ),
      GoRoute(
        path: MainView.routeName,
        name: MainView.routeName,
        builder: (context, state) {
          final userEntity = state.extra as UserEntity?;
          if (userEntity == null) {
            return const Scaffold(
                body: Center(child: Text('User data missing')));
          }
          // Fallback check:
          if (!getIt.isRegistered<NotificationsCubit>()) {
            registerNotificationsCubitSingleton(userEntity.uId);
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<NotificationsCubit>(),
              ),
            ],
            child: MainView(userData: userEntity),
          );
        },
      ),
      // OTP Verification Route
      GoRoute(
        path: OtpVerficationView.routeName,
        name: OtpVerficationView.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            return const Scaffold(
                body: Center(child: Text('Missing route arguments')));
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider<OtpVerifyCubit>(
                create: (_) => OtpVerifyCubit(getIt.get<AuthRepo>()),
              ),
              BlocProvider<OtpResendTimerCubit>(
                create: (_) => OtpResendTimerCubit(),
              ),
            ],
            child: OtpVerficationView(
              email: args[kEmail] as String,
              image: args[kImage] as String?,
              nextRoute: args[kNextRoute] as String,
              id: args[kId] as String,
              isRegister: args[kIsRegister] as bool,
            ),
          );
        },
      ),
      // Forget Password Route
      GoRoute(
        path: ForgetPasswordView.routeName,
        name: ForgetPasswordView.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => ResetPasswordCubit(getIt.get<AuthRepo>()),
            child: const ForgetPasswordView(),
          );
        },
      ),
      // Reset Password Route
      GoRoute(
        path: ResetPasswordView.routeName,
        name: ResetPasswordView.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            return const Scaffold(
                body: Center(child: Text('Missing route arguments')));
          }
          return BlocProvider(
            create: (_) => ResetPasswordCubit(getIt.get<AuthRepo>()),
            child: ResetPasswordView(
              email: args[kEmail] as String,
              otp: args[kOtp] as String,
            ),
          );
        },
      ),
      // Personal Data Route
      GoRoute(
        path: PersonalDataView.routeName,
        name: PersonalDataView.routeName,
        builder: (context, state) {
          final id = state.extra as String?;
          return PersonalDataView(id: id ?? '');
        },
      ),
      // Store Details Route
      GoRoute(
        path: StoreDetailView.routeName,
        name: StoreDetailView.routeName,
        builder: (context, state) {
          final id = state.extra as String?;
          return BlocProvider(
            create: (_) => StoreDetailCubit(
              storesRepo: getIt<StoresRepo>(),
              couponsRepo: getIt<CouponsRepo>(),
            ),
            child: StoreDetailView(storeId: id ?? ''),
          );
        },
      ),
      // Search Route
      GoRoute(
        path: SearchView.routeName,
        name: SearchView.routeName,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => StoresCubit(storesRepo: getIt<StoresRepo>()),
              ),
              BlocProvider(
                create: (_) => CategoriesCubit(
                    categoriesRepo: getIt.get<CategoriesRepo>()),
              ),
            ],
            child: const SearchView(),
          );
        },
      ),
      GoRoute(
        path: StoresView.routeName,
        name: StoresView.routeName,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => StoresCubit(storesRepo: getIt<StoresRepo>()),
              ),
              BlocProvider(
                create: (_) => CategoriesCubit(
                    categoriesRepo: getIt.get<CategoriesRepo>()),
              ),
            ],
            child: const StoresView(),
          );
        },
      ),
      GoRoute(
        path: CouponView.routeName,
        name: CouponView.routeName,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => CouponsCubit(couponsRepo: getIt<CouponsRepo>()),
              ),
              BlocProvider(
                create: (_) => CategoriesCubit(
                    categoriesRepo: getIt.get<CategoriesRepo>()),
              ),
            ],
            child: const CouponView(),
          );
        },
      ),
      // Coupon Details Route
      GoRoute(
        path: CouponDetailsView.routeName,
        name: CouponDetailsView.routeName,
        builder: (context, state) {
          final id = state.extra as String?;
          return BlocProvider(
            create: (_) => CouponDetailCubit(couponsRepo: getIt<CouponsRepo>()),
            child: CouponDetailsView(couponId: id ?? ''),
          );
        },
      ),
      // NotificationsView Route: Use the existing NotificationsCubit.
      GoRoute(
        path: NotificationsView.routeName,
        name: NotificationsView.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, String>? ?? {};
          final userId = args['userId'] ?? 'defaultUserId';
          final token = args['token'] ?? '';
          // If not registered, fallback registration.
          if (!getIt.isRegistered<NotificationsCubit>()) {
            registerNotificationsCubitSingleton(userId);
          }
          return BlocProvider.value(
            value: getIt<NotificationsCubit>(),
            child: NotificationsView(userId: userId, token: token),
          );
        },
      ),
    ],
  );
}
