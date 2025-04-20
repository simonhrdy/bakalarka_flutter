import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/widgets/responsive/responsive_row_column.dart';

class MatchDateAndRoundFields extends StatelessWidget {
  const MatchDateAndRoundFields({
    super.key,
    required this.dateTimeController,
    required this.roundController,
  });

  final TextEditingController dateTimeController;
  final TextEditingController roundController;

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowOrColumn(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.dateTimeLabel,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            FormTextField(
              controller: dateTimeController,
              hintText: context.l10n.dateTimeLabel,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    final dt = DateTime(
                        date.year, date.month, date.day, time.hour, time.minute);
                    dateTimeController.text =
                        DateFormat('yyyy-MM-dd HH:mm').format(dt);
                  }
                }
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.roundLabel,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            FormTextField(
              controller: roundController,
              hintText: context.l10n.roundLabel,
            ),
          ],
        ),
      ],
    );
  }
}
