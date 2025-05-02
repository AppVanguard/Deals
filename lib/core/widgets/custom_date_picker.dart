import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate; // ← NEW
  final ValueChanged<DateTime> onDateSelected;
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
