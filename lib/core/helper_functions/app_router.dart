import 'package:deals/constants.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';
import 'package:deals/features/auth/presentation/views/forget_password/forget_password_view.dart';
import 'package:deals/features/auth/presentation/views/otp_verification/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/user_update/user_update_view.dart';
import 'package:deals/features/auth/presentation/views/reset_password/reset_password_view.dart';
import 'package:deals/features/auth/presentation/views/signin/signin_view.dart';
import 'package:deals/features/auth/presentation/views/signup/signup_view.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmark_repo.dart';
import 'package:deals/features/bookmarks/presentation/manager/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupon_details_cubit/coupon_detail_cubit.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:deals/features/coupons/presentation/views/coupon_details_view.dart';
import 'package:deals/features/coupons/presentation/views/coupon_view.dart';
import 'package:deals/features/faq/presentation/views/faq_view.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/notifications/presentation/views/notifications_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:deals/features/personal_data/data/repos/presonal_data_repo_impl.dart';
import 'package:deals/features/personal_data/presentation/manager/personal_data_cubit.dart';
import 'package:deals/features/personal_data/presentation/views/personal_data_view.dart';
import 'package:deals/features/privacy_and_policy/presentation/views/privacy_and_policy_view.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';
import 'package:deals/features/settings/presentation/manager/settings_cubit.dart';
import 'package:deals/features/settings/presentation/views/change_password_view.dart';
import 'package:deals/features/settings/presentation/views/delete_account_view.dart';
import 'package:deals/features/settings/presentation/views/settings_view.dart';
import 'package:deals/features/settings/presentation/views/widgets/deleted_success_screen.dart';
import 'package:deals/features/splash/presentation/views/splash_view.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:deals/features/stores/presentation/views/stores_view.dart';
import 'package:deals/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:deals/features/terms_and_conditions/presentation/views/terms_and_conditions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashView.routeName,
    routes: [
      ..._authRoutes,
      ..._mainRoutes,
      ..._storeRoutes,
      ..._couponRoutes,
      ..._notificationsRoutes,
      ..._settingsRoutes,
    ],
  );

  static final List<GoRoute> _authRoutes = [
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
    // OTP Verification Route
    GoRoute(
      path: OtpVerficationView.routeName,
      name: OtpVerficationView.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const Scaffold(
            body: Center(child: Text('Missing route arguments')),
          );
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
            finalRoute: args[kFinalRoute] as String? ?? SigninView.routeName,
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
      builder: (context, state) => BlocProvider(
        create: (_) => ResetPasswordCubit(getIt.get<AuthRepo>()),
        child: const ForgetPasswordView(),
      ),
    ),
    // Reset Password Route
    GoRoute(
      path: ResetPasswordView.routeName,
      name: ResetPasswordView.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const Scaffold(body: Center(child: Text('Missing args')));
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
  ];

  static final List<GoRoute> _mainRoutes = [
    GoRoute(
      path: MainView.routeName,
      name: MainView.routeName,
      builder: (context, state) {
        final userEntity = state.extra as UserEntity?;
        if (userEntity == null) {
          return const Scaffold(body: Center(child: Text('User data missing')));
        }
        if (!getIt.isRegistered<NotificationsCubit>()) {
          registerNotificationsCubitSingleton(userEntity.uId);
        }
        return MultiBlocProvider(
          providers: [BlocProvider.value(value: getIt<NotificationsCubit>())],
          child: MainView(userData: userEntity),
        );
      },
    ),
    GoRoute(
      path: UserUpdateView.routeName,
      name: UserUpdateView.routeName,
      builder: (context, state) {
        final id = state.extra as String?;
        return UserUpdateView(id: id ?? '', token: '');
      },
    ),
  ];

  static final List<GoRoute> _storeRoutes = [
    GoRoute(
      path: StoreDetailView.routeName,
      name: StoreDetailView.routeName,
      builder: (context, state) {
        final id = state.extra as String?;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => StoreDetailCubit(
                storesRepo: getIt<StoresRepo>(),
                couponsRepo: getIt<CouponsRepo>(),
              ),
            ),
            BlocProvider(
              create: (_) => BookmarkCubit(repo: getIt<BookmarkRepo>()),
            ),
          ],
          child: StoreDetailView(storeId: id ?? ''),
        );
      },
    ),
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
              create: (_) =>
                  CategoriesCubit(categoriesRepo: getIt.get<CategoriesRepo>()),
            ),
            BlocProvider(create: (_) => SearchCubit()),
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
              create: (_) =>
                  CategoriesCubit(categoriesRepo: getIt.get<CategoriesRepo>()),
            ),
            BlocProvider(create: (_) => SearchCubit()),
          ],
          child: const StoresView(),
        );
      },
    ),
  ];

  static final List<GoRoute> _couponRoutes = [
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
              create: (_) =>
                  CategoriesCubit(categoriesRepo: getIt.get<CategoriesRepo>()),
            ),
            BlocProvider(create: (_) => SearchCubit()),
          ],
          child: const CouponView(),
        );
      },
    ),
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
  ];

  static final List<GoRoute> _notificationsRoutes = [
    GoRoute(
      path: NotificationsView.routeName,
      name: NotificationsView.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, String>? ?? {};
        final userId = args['userId'] ?? 'defaultUserId';
        final token = args['token'] ?? '';
        if (!getIt.isRegistered<NotificationsCubit>()) {
          registerNotificationsCubitSingleton(userId);
        }
        return BlocProvider.value(
          value: getIt<NotificationsCubit>(),
          child: NotificationsView(userId: userId, token: token),
        );
      },
    ),
  ];

  static final List<GoRoute> _settingsRoutes = [
    GoRoute(
      path: TermsAndConditionsView.routeName,
      name: TermsAndConditionsView.routeName,
      builder: (context, state) => const TermsAndConditionsView(),
    ),
    GoRoute(
      path: PrivacyAndPolicyView.routeName,
      name: PrivacyAndPolicyView.routeName,
      builder: (context, state) => const PrivacyAndPolicyView(),
    ),
    GoRoute(
      path: FaqView.routeName,
      name: FaqView.routeName,
      builder: (context, state) {
        return const FaqView();
      },
    ),
    GoRoute(
      path: PersonalDataView.routeName,
      name: PersonalDataView.routeName,
      builder: (context, state) {
        final id = state.extra as String? ?? '';
        return BlocProvider<PersonalDataCubit>(
          create: (_) => PersonalDataCubit(
            repo: PersonalDataRepoImpl(userService: getIt()),
            userId: id,
          ),
          child: PersonalDataView(id: id),
        );
      },
    ),
    GoRoute(
      path: SettingsView.routeName,
      name: SettingsView.routeName,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SettingsCubit(repo: getIt<SettingsRepo>()),
          child: const SettingsView(),
        );
      },
    ),
    GoRoute(
      path: DeleteAccountView.routeName,
      name: DeleteAccountView.routeName,
      builder: (context, state) => BlocProvider(
        create: (_) => SettingsCubit(repo: getIt<SettingsRepo>()),
        child: const DeleteAccountView(),
      ),
    ),
    GoRoute(
      path: DeletedSuccessScreen.routeName,
      name: DeletedSuccessScreen.routeName,
      builder: (context, state) => const DeletedSuccessScreen(),
    ),
    GoRoute(
      path: ChangePasswordView.routeName,
      name: ChangePasswordView.routeName,
      builder: (context, state) => BlocProvider(
        create: (_) => SettingsCubit(repo: getIt<SettingsRepo>()),
        child: const ChangePasswordView(),
      ),
    ),
  ];
}
