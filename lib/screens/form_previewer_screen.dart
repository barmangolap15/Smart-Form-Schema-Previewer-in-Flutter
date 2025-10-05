import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/form_schema_model.dart';
import '../widgets/dynamic_form_field.dart';

class FormPreviewerScreen extends StatefulWidget {
  const FormPreviewerScreen({super.key});

  @override
  State<FormPreviewerScreen> createState() => _FormPreviewerScreenState();
}

class _FormPreviewerScreenState extends State<FormPreviewerScreen> {
  final _jsonController = TextEditingController();
  FormSchema? _schema;
  final Map<String, dynamic> _formData = {};
  final _formKey = GlobalKey<FormState>();

  void _openJsonDialog({bool isEdit = false}) {
    if (isEdit && _schema != null) {
      // keep current JSON text for editing
      _jsonController.text = const JsonEncoder.withIndent('  ').convert({
        "title": _schema!.title,
        "fields": _schema!.fields.map((f) => f.toJson()).toList(),
      });
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit JSON Schema' : 'Add JSON Schema'),
        content: TextField(
          style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
          controller: _jsonController,
          decoration: const InputDecoration(
            hintText: 'Paste JSON schema here',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              try {
                final decoded = json.decode(_jsonController.text);
                final pretty = const JsonEncoder.withIndent(
                  '  ',
                ).convert(decoded);
                _jsonController.text = pretty; // format before saving
              } catch (_) {
                // ignore invalid JSON
              }
              _loadSchemaFromText();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _loadSchemaFromText() {
    try {
      final decoded = json.decode(_jsonController.text);
      if (decoded is Map<String, dynamic> && decoded.containsKey('fields')) {
        _schema = FormSchema.fromJson(decoded);
      } else if (decoded is List) {
        _schema = FormSchema(
          title: 'Untitled form',
          fields: decoded
              .map(
                (e) => FormFieldSchema.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList(),
        );
      } else {
        throw Exception(
          'Please provide a JSON object with "fields" or a list of fields.',
        );
      }
      _formData.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid JSON: ${e.toString()}')));
    }
  }

  void _submitForm() {
    final basicValid = _formKey.currentState?.validate() ?? true;
    if (!basicValid) return;

    if (_schema != null) {
      for (final f in _schema!.fields) {
        if (f.required) {
          final v = _formData[f.label];
          final empty =
              v == null ||
              (v is String && v.trim().isEmpty) ||
              (v is Iterable && v.isEmpty) ||
              (v is bool && v == false && f.type == 'checkbox');
          if (empty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Please fill: ${f.label}')));
            return;
          }
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Form result'),
        content: SingleChildScrollView(
          child: Text(const JsonEncoder.withIndent('  ').convert(_formData)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSchema = _schema != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Smart Form Schema Previewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Top button(s)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openJsonDialog(isEdit: hasSchema),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.data_object),
                    label: Text(
                      hasSchema ? 'JSON Data Added' : 'Add JSON Data',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                if (hasSchema) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _openJsonDialog(isEdit: true),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submitForm,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit'),
                  ),
                ],
              ],
            ),
            const Divider(),

            // Show form
            if (_schema != null)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, ),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        Text(
                          _schema!.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ..._schema!.fields.map((f) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: DynamicFormField(
                              field: f,
                              initialValue: _formData[f.label],
                              onChanged: (label, val) {
                                setState(() {
                                  _formData[label] = val;
                                });
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
