import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/entries/entities/entry.dart';
import '../entries_controller.dart';

class EntryEditorScreen extends StatefulWidget {
  final Entry? existing;

  const EntryEditorScreen({super.key, this.existing});

  @override
  State<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends State<EntryEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;

  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.existing?.content ?? '');
    _date = widget.existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  String? _validateTitle(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Заголовок обязателен';
    if (value.length < 3) return 'Минимум 3 символа';
    return null;
  }

  String? _validateContent(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Текст обязателен';
    if (value.length < 10) return 'Минимум 10 символов';
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _date = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _date.hour,
        _date.minute,
      );
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await context.read<EntriesController>().save(
          existing: widget.existing,
          title: _titleCtrl.text,
          content: _contentCtrl.text,
          date: _date,
        );
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final dateText = '${_date.day.toString().padLeft(2, '0')}.'
        '${_date.month.toString().padLeft(2, '0')}.'
        '${_date.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать запись' : 'Новая запись'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Заголовок',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateTitle,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentCtrl,
                  minLines: 6,
                  maxLines: 12,
                  decoration: const InputDecoration(
                    labelText: 'Текст',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: _validateContent,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text('Дата: $dateText'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

