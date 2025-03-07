import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:deals/generated/l10n.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final String? Function(DateTime?)? validator;

  const CustomDatePicker(
      {super.key, required this.onDateSelected, this.validator});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  String? _errorText;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
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
                errorText: _errorText, // Display validation error
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Colors.grey),
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
      ),
    );
  }
}
