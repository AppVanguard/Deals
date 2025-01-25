import 'package:flutter/material.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';
import 'package:in_pocket/generated/l10n.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    this.onSaved,
  });
  final void Function(String?)? onSaved;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: S.of(context).Password,
      obscureText: obscureText,
      onSaved: widget.onSaved,
      suffixIcon: IconButton(
        onPressed: () => setState(() {
          obscureText = !obscureText;
        }),
        icon: obscureText
            ? const Icon(Icons.remove_red_eye)
            : const Icon(Icons.visibility_off),
        color: const Color(0xffc9cecf),
      ),
      hintText: 'كلمة المرور',
      textInputType: TextInputType.visiblePassword,
    );
  }
}
