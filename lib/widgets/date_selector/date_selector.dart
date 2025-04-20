import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/config/extensions/extensions.dart';

class DateSelector extends StatefulWidget {
  final void Function(DateTime) onDateChanged;
  final DateTime? initialDate;

  const DateSelector({
    required this.onDateChanged,
    this.initialDate,
    super.key,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateChanged(selectedDate);
    });
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    widget.onDateChanged(selectedDate);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white, width: 3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Arrow
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _changeDate(-1),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              color: Colors.black,
              splashRadius: 20,
            ),
          ),

          // 📅 Date text with tap-to-open
          GestureDetector(
            onTap: _pickDate,
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d.M.yyyy').format(selectedDate),
                  style: context.textTheme.body,
                ),
              ],
            ),
          ),

          // Right Arrow
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _changeDate(1),
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              color: Colors.black,
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}
