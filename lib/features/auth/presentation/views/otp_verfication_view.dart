import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:deals/features/auth/presentation/manager/cubits/otp_resend_timer_cubit/otp_resend_timer_cubit.dart';
import 'package:deals/features/auth/presentation/views/widgets/otp_verfication_bloc_consumer.dart';

class OtpVerficationView extends StatelessWidget {
  const OtpVerficationView({
    super.key,
    required this.email,
    this.image,
    required this.nextRoute,
    required this.id,
    required this.isRegister,
  });

  final String email;
  final String? image;
  final String nextRoute;
  final String id;
  final bool isRegister;
  static const routeName = 'otp_verfication_view';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpVerifyCubit>(
          create: (_) => OtpVerifyCubit(getIt.get<AuthRepo>()),
        ),
        BlocProvider<OtpResendTimerCubit>(
          create: (_) => OtpResendTimerCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: OTPVeficationBlocConsumer(
          id: id,
          image: image,
          email: email,
          path: nextRoute,
          isRegister: isRegister,
        ),
      ),
    );
  }
}
