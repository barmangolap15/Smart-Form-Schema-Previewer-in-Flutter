import 'package:flutter/foundation.dart';

class FormSchema {
  final String title; // form title
  final List<FormFieldSchema> fields; // form

  FormSchema({required this.title, required this.fields});

  factory FormSchema.fromJson(Map<String, dynamic> json) {
    final fieldsJson = (json['fields'] is List) ? json['fields'] as List : [];
    return FormSchema(
      title: json['title']?.toString() ?? '',
      fields: fieldsJson
          .map((e) => FormFieldSchema.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class FormFieldSchema {
  final String name; // unique key; use this to store values
  final String label; // labels for display text
  final String type; // text, email, number, dropdown, radio, checkbox, switch, slider, date, time, multiselect
  final bool required; // validation
  final List<String>? options; // for dropdowns, radio etc. those have multiple items as options

  FormFieldSchema({
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.options,
  });

  factory FormFieldSchema.fromJson(Map<String, dynamic> json) {
    return FormFieldSchema(
      name: json['name']?.toString() ??
          json['label']?.toString() ??
          UniqueKey().toString(),
      label: json['label']?.toString() ?? json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      required: json['required'] == true,
      options: json['options'] != null
          ? List<String>.from(json['options'].map((e) => e.toString()))
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'label': label,
      'type': type,
      'required': required,
      if (options != null) 'options': options,
    };
  }
}
