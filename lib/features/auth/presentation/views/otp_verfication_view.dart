import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/service/get_it_service.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/features/auth/presentation/manager/cubits/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/otp_verfication_bloc_consumer.dart';

class OtpVerficationView extends StatelessWidget {
  const OtpVerficationView({
    super.key,
    required this.email,
    this.image,
    required this.nextRoute,
    required this.id,
  });

  final String email;
  final String? image;
  final String nextRoute;
  final String id;
  static const routeName = 'otp_verfication_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpVerifyCubit(getIt.get<AuthRepo>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: OTPVeficationBlocConsumer(
          id: id,
          image: image,
          email: email,
          path: nextRoute,
        ),
      ),
    );
  }
}
