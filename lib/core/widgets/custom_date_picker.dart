import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:intl/intl.dart';

/// A lightweight wrapper around [DatePicker] that displays the selected date
/// and handles validation.
///
/// The picker initially shows [initialDate] if provided and notifies
/// [onDateSelected] whenever the user chooses a new date.

class CustomDatePicker extends StatefulWidget {
  /// Initially selected date in the picker.
  final DateTime? initialDate; // ← NEW

  /// Called when the user selects a date.
  final ValueChanged<DateTime> onDateSelected;

  /// Optional validation logic for the chosen date.
  final String? Function(DateTime?)? validator;

  const CustomDatePicker({
    super.key,
    this.initialDate, // ← NEW
    required this.onDateSelected,
    this.validator,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate; // ← PREFILL
    _errorText = widget.validator?.call(_selectedDate);
  }

  void _showDatePicker() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
      titleText: "",
      context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
      dateFormat: "dd-MMM-yyyy",
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _errorText = widget.validator?.call(_selectedDate);
      });
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDatePicker,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: S.of(context).BirthDate,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              errorText: _errorText,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat("dd/MM/yyyy").format(_selectedDate!)
                        : S.of(context).SelectDate,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
