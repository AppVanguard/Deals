import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:deals/features/auth/presentation/views/otp_verification/widgets/otp_verfication_bloc_consumer.dart';

class OtpVerficationView extends StatelessWidget {
  const OtpVerficationView({
    super.key,
    required this.email,
    this.image,
    required this.nextRoute,
    required this.id,
    required this.isRegister,
    required this.finalRoute,
  });

  final String email;
  final String? image;
  final String nextRoute; // e.g. 'reset-password' or 'personal_data_view'
  final String id;
  final bool isRegister;
  final String finalRoute;

  static const routeName = '/otp_verfication_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background),
      body: OTPVeficationBlocConsumer(
        id: id,
        image: image,
        email: email,
        path: nextRoute,
        finalRoute: finalRoute, // pass down
        isRegister: isRegister,
      ),
    );
  }
}
