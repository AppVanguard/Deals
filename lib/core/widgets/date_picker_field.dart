import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CustomDatePicker({super.key, required this.onDateSelected});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  void _showPopupPicker(BuildContext context) {
    final now = DateTime.now();
    final startYear = now.year - 100;
    final endYear = now.year;

    Picker(
      adapter: DateTimePickerAdapter(
        type: PickerDateTimeType.kYMD,
        yearBegin: startYear,
        yearEnd: endYear,
        value: _selectedDate ?? now,
      ),
      hideHeader: true,
      height: 250,
      backgroundColor: Colors.white,
      containerColor: Colors.white,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      selectedTextStyle: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _headerLabel("Month"),
                _headerLabel("Year"),
                _headerLabel("Day"),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      headerDecoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      confirm: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Save",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onConfirm: (Picker picker, List<int> selected) {
        final DateTime pickedDate =
            (picker.adapter as DateTimePickerAdapter).value!;
        setState(() {
          _selectedDate = pickedDate;
        });
        widget.onDateSelected(pickedDate);
      },
    ).showDialog(context);
  }

  Widget _headerLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5FFEE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF00AD37),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopupPicker(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Birth date",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedDate != null
                    ? DateFormat("dd/MM/yyyy").format(_selectedDate!)
                    : "Select Date",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
