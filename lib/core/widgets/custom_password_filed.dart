import 'package:flutter/material.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.label,
    required this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.borderColor, // NEW
  });

  final String label;
  final String? Function(String?) validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Color? borderColor; // NEW

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: widget.label,
      hintText: widget.label,
      textInputType: TextInputType.visiblePassword,
      obscureText: _obscure,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      borderColor: widget.borderColor, // PASS‑THROUGH
      suffixIcon: IconButton(
        icon: _obscure
            ? const Icon(Icons.remove_red_eye_outlined)
            : const Icon(Icons.visibility_off_outlined),
        color: const Color(0xffc9cecf),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
