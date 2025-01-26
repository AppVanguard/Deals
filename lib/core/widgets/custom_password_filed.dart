import 'package:flutter/material.dart';
import 'package:in_pocket/core/widgets/custom_text_form_field.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    this.onSaved,
    required this.label,
    required this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });
  final void Function(String?)? onSaved;
  final String label;
  final String? Function(String?) validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      label: widget.label,
      obscureText: obscureText,
      onSaved: widget.onSaved,
      suffixIcon: IconButton(
        onPressed: () => setState(() {
          obscureText = !obscureText;
        }),
        icon: obscureText
            ? const Icon(Icons.remove_red_eye_outlined)
            : const Icon(Icons.visibility_off_outlined),
        color: const Color(0xffc9cecf),
      ),
      hintText: widget.label,
      textInputType: TextInputType.visiblePassword,
    );
  }
}
