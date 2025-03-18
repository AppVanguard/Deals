import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:deals/features/search/presentation/views/search_view.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/features/splash/presentation/views/splash_view.dart';
import 'package:deals/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:deals/features/auth/presentation/views/signin_view.dart';
import 'package:deals/features/auth/presentation/views/signup_view.dart';
import 'package:deals/features/auth/presentation/views/otp_verfication_view.dart';
import 'package:deals/features/auth/presentation/views/forget_password_view.dart';
import 'package:deals/features/auth/presentation/views/reset_password_view.dart';
import 'package:deals/features/auth/presentation/views/personal_data_view.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/main/presentation/views/main_view.dart';
import 'package:deals/constants.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signin_cubit/signin_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/signup_cubit/signup_cubit.dart';

class AppRouter {
  /// Our single [GoRouter] instance.
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

      // Sign In Route
      GoRoute(
        path: SigninView.routeName,
        name: SigninView.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => SigninCubit(getIt.get<AuthRepo>()),
            child: const SigninView(),
          );
        },
      ),

      // Sign Up Route
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

      // MainView Route (providing CategoriesCubit here)
      GoRoute(
        path: MainView.routeName,
        name: MainView.routeName,
        builder: (context, state) {
          final userEntity = state.extra as UserEntity?;
          return MultiBlocProvider(
            providers: [
              BlocProvider<CategoriesCubit>(
                create: (_) => CategoriesCubit(
                  categoriesRepo: getIt<CategoriesRepo>(),
                ),
              ),
            ],
            child: MainView(userData: userEntity!),
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
            create: (_) => ResetPasswordCubit(getIt<AuthRepo>()),
            child: const ForgetPasswordView()),
      ),

      // Reset Password Route
      GoRoute(
        path: ResetPasswordView.routeName,
        name: ResetPasswordView.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Missing route arguments')),
            );
          }
          return BlocProvider(
              create: (_) => ResetPasswordCubit(getIt.get<AuthRepo>()),
              child: ResetPasswordView(
                email: args[kEmail] as String,
                otp: args[kOtp] as String,
              ));
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
            child: StoreDetailView(
              storeId: id ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: SearchView.routeName,
        name: SearchView.routeName,
        builder: (context, state) => MultiBlocProvider(providers: [
          BlocProvider(
            create: (_) => StoresCubit(
              storesRepo: getIt<StoresRepo>(),
            ),
          ),
          BlocProvider(
            create: (_) => CategoriesCubit(
              categoriesRepo: getIt<CategoriesRepo>(),
            ),
          )
        ], child: const SearchView()),
      )
    ],
  );
}
