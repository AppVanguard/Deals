import 'package:flutter/material.dart';
import 'package:deals/core/widgets/custom_text_form_field.dart';

/// A password text field that exposes a toggle to show or hide the value.
///
/// This widget reuses [CustomTextFormField] but adds an eye icon suffix that
/// allows the user to reveal or obscure the entered password.

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

  /// Label and hint text for the password field.
  final String label;

  /// Validation callback returning an error message if invalid.
  final String? Function(String?) validator;

  /// Called when the form is saved.
  final void Function(String?)? onSaved;

  /// Called on every value change.
  final void Function(String)? onChanged;

  /// Called when the user submits from the keyboard.
  final void Function(String)? onFieldSubmitted;

  /// Border color for the inner [CustomTextFormField].
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
