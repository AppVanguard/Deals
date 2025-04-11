import 'package:flutter/material.dart';
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
  final String nextRoute; // e.g. 'reset-password' or 'personal_data_view'
  final String id;
  final bool isRegister;

  static const routeName = '/otp_verfication_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: OTPVeficationBlocConsumer(
        id: id,
        image: image,
        email: email,
        path: nextRoute,
        isRegister: isRegister,
      ),
    );
  }
}
