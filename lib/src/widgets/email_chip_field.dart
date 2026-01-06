import 'package:flutter/material.dart';
import '../chip_email_controller.dart';

/// A modern text field for entering emails and generating chips.
/// Supports batch parsing and real-time feedback.
class EmailChipField extends StatefulWidget {
  final ChipEmailController controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final List<String> delimiters;

  const EmailChipField({
    super.key,
    required this.controller,
    this.decoration,
    this.style,
    this.delimiters = const [' ', ',', ';'],
  });

  @override
  State<EmailChipField> createState() => _EmailChipFieldState();
}

class _EmailChipFieldState extends State<EmailChipField> {
  final TextEditingController _textController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    if (value.trim().isEmpty) return;

    // Check if it's a batch paste or multiple emails
    if (value.contains('@') &&
        (value.contains(',') || value.contains(' ') || value.contains(';'))) {
      widget.controller.parseAndAddEmails(value);
      _textController.clear();
      setState(() => _errorText = null);
      return;
    }

    // Single email validation
    final error = widget.controller.validator.getValidationError(value);
    if (error == null) {
      if (widget.controller.addEmail(value)) {
        _textController.clear();
        setState(() => _errorText = null);
      } else {
        setState(() => _errorText = 'Email already added');
      }
    } else {
      setState(() => _errorText = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      style: widget.style,
      decoration: (widget.decoration ??
              const InputDecoration(
                hintText: 'Enter email...',
                border: OutlineInputBorder(),
              ))
          .copyWith(
        errorText: _errorText,
      ),
      onChanged: (value) {
        if (value.isNotEmpty &&
            widget.delimiters.contains(value.characters.last)) {
          final email = value.substring(0, value.length - 1);
          _handleSubmitted(email);
        } else if (_errorText != null) {
          setState(() => _errorText = null);
        }
      },
      onSubmitted: _handleSubmitted,
    );
  }
}
