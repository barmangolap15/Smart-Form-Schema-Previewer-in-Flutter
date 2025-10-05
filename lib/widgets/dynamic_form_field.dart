import 'package:flutter/material.dart';
import '../models/form_schema_model.dart';

class DynamicFormField extends StatelessWidget {
  final FormFieldSchema field;
  final Function(String, dynamic) onChanged;
  final dynamic initialValue;

  const DynamicFormField({
    super.key,
    required this.field,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case 'text':
      case 'email':
      case 'number':
        return TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(labelText: field.label),
          keyboardType: field.type == 'number'
              ? TextInputType.number
              : (field.type == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text),
          validator: field.required
              ? (val) => val == null || val.isEmpty ? 'Required field' : null
              : null,
          onChanged: (val) => onChanged(field.label, val),
        );

      case 'dropdown':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: field.label),
          value: initialValue,
          items: field.options!
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: (val) => onChanged(field.label, val),
          validator: field.required
              ? (val) => val == null ? 'Please select' : null
              : null,
        );

      case 'radio':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...field.options!.map((opt) => RadioListTile(
              title: Text(opt),
              value: opt,
              groupValue: initialValue,
              onChanged: (val) => onChanged(field.label, val),
            )),
          ],
        );

      case 'checkbox':
        return CheckboxListTile(
          title: Text(field.label),
          value: initialValue ?? false,
          onChanged: (val) => onChanged(field.label, val),
        );

      case 'switch':
        return SwitchListTile(
          title: Text(field.label),
          value: initialValue ?? false,
          onChanged: (val) => onChanged(field.label, val),
        );

      case 'slider':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label),
            Slider(
              value: (initialValue ?? 0).toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              label: '${initialValue ?? 0}',
              onChanged: (val) => onChanged(field.label, val.round()),
            ),
          ],
        );

      case 'date':
        return ListTile(
          title: Text(field.label),
          subtitle: Text(initialValue != null ? initialValue.toString() : 'Select date'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onChanged(field.label, picked.toString().split(' ')[0]);
            }
          },
        );

      case 'time':
        return ListTile(
          title: Text(field.label),
          subtitle: Text(initialValue != null ? initialValue.toString() : 'Select time'),
          trailing: const Icon(Icons.access_time),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              onChanged(field.label, picked.format(context));
            }
          },
        );

      default:
        return Text('Unsupported field: ${field.type}');
    }
  }
}
