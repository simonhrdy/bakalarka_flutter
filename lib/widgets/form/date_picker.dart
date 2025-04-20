import 'package:flutter/material.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

class FormDatePickerField extends StatelessWidget {
  const FormDatePickerField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hintText = 'YYYY-MM-DD',
    this.validator,
    this.label,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String? Function(String?)? validator;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          TextFormFieldLabel(text: label!),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: controller.text.isNotEmpty
                  ? DateTime.tryParse(controller.text) ?? DateTime.now()
                  : DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              controller.text = picked.toIso8601String().split('T').first;
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                suffixIcon: const Icon(Icons.calendar_today),
                border: const OutlineInputBorder(),
              ),
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }
}