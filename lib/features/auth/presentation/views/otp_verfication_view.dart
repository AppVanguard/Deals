import 'package:flutter/material.dart';
import 'package:in_pocket/features/auth/presentation/views/widgets/otp_verfication_view_body.dart';

class OtpVerficationView extends StatelessWidget {
  const OtpVerficationView({super.key, required this.email});
  final String email;
  static const routeName = 'otp_verfication_view';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: OTPVerificationViewBody(
          email: email,
        ));
  }
}
