import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../parser.dart';

/// Behaves like a standard [FormField], making it a robust developer tool.
class EmailChipInput extends FormField<List<String>> {
  final ChipEmailController? controller;
  final InputDecoration decoration;
  final void Function(List<String>)? onChanged;
  final List<String> delimiters;

  /// Custom style for the chips.
  final EmailChipStyle chipStyle;

  EmailChipInput({
    super.key,
    this.controller,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.delimiters = const [' ', ',', ';'],
    this.chipStyle = const EmailChipStyle(),
    super.validator,
    super.onSaved,
    List<String>? initialValue,
    super.enabled = true,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          initialValue: controller?.value ?? initialValue ?? [],
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<List<String>> field) {
            final _EmailChipInputState state = field as _EmailChipInputState;
            final InputDecoration effectiveDecoration = (decoration)
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return Container(
              decoration: BoxDecoration(
                border: effectiveDecoration.border != null &&
                        effectiveDecoration.border != InputBorder.none
                    ? null // Let the InputDecorator handle the border
                    : null,
              ),
              child: GestureDetector(
                onTap: () => state._textFieldFocusNode.requestFocus(),
                behavior: HitTestBehavior.opaque,
                child: InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: field.errorText,
                    enabled: enabled,
                  ),
                  isFocused: state._isFocused,
                  isEmpty: (field.value?.isEmpty ?? true) &&
                      state._textController.text.isEmpty,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...state._buildChips(field.value ?? []),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 50),
                        child: IntrinsicWidth(
                          child: KeyboardListener(
                            focusNode: state._keyboardFocusNode,
                            onKeyEvent: (event) =>
                                state._handleKeyEvent(event, field),
                            child: TextField(
                              controller: state._textController,
                              focusNode: state._textFieldFocusNode,
                              enabled: enabled,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) =>
                                  state._onTextChanged(val, field),
                              onSubmitted: (val) =>
                                  state._onTextSubmitted(val, field),
                              style: effectiveDecoration.hintStyle?.copyWith(
                                  color: Theme.of(field.context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

  @override
  FormFieldState<List<String>> createState() => _EmailChipInputState();
}

class _EmailChipInputState extends FormFieldState<List<String>> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();

  bool _isFocused = false;
  int? _selectedChipIndex;

  @override
  EmailChipInput get widget => super.widget as EmailChipInput;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleControllerChanged);
    _textFieldFocusNode.addListener(_handleFocusChange);
    _textController.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _textFieldFocusNode.removeListener(_handleFocusChange);
    _textController.removeListener(_handleTextChange);
    _textController.dispose();
    _textFieldFocusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _textFieldFocusNode.hasFocus;
    });
  }

  void _handleControllerChanged() {
    if (widget.controller != null && widget.controller!.value != value) {
      didChange(widget.controller!.value);
    }
  }

  @override
  void didChange(List<String>? value) {
    super.didChange(value);
    if (widget.controller != null && widget.controller!.value != value) {
      widget.controller!.value = value ?? [];
    }
    if (widget.onChanged != null) {
      widget.onChanged!(value ?? []);
    }
  }

  void _handleKeyEvent(KeyEvent event, FormFieldState<List<String>> field) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_textController.text.isEmpty) {
        final current = field.value ?? [];
        if (current.isNotEmpty) {
          if (_selectedChipIndex == null) {
            // First backspace: select last chip
            setState(() => _selectedChipIndex = current.length - 1);
          } else {
            // Second backspace: remove selected chip
            final updated = List<String>.from(current);
            updated.removeAt(_selectedChipIndex!);
            setState(() => _selectedChipIndex = null);
            didChange(updated);
          }
        }
      }
    } else if (event is KeyDownEvent) {
      // Any other key clears selection
      if (_selectedChipIndex != null) {
        setState(() => _selectedChipIndex = null);
      }
    }
  }

  void _onTextChanged(String val, FormFieldState<List<String>> field) {
    if (val.isNotEmpty && widget.delimiters.contains(val.characters.last)) {
      final email = val.substring(0, val.length - 1);
      _processEmail(email, field);
    }
  }

  void _onTextSubmitted(String val, FormFieldState<List<String>> field) {
    _processEmail(val, field);
  }

  void _processEmail(String text, FormFieldState<List<String>> field) {
    if (text.trim().isEmpty) return;

    final current = List<String>.from(field.value ?? []);
    final found = ChipEmailParser.parse(text);

    if (found.isEmpty) return;

    bool changed = false;
    for (var email in found) {
      if (!current.contains(email)) {
        current.add(email);
        changed = true;
      }
    }

    if (changed) {
      _textController.clear();
      didChange(current);
    }
  }

  List<Widget> _buildChips(List<String> emails) {
    final List<Widget> items = [];
    for (int i = 0; i < emails.length; i++) {
      final email = emails[i];
      final isSelected = _selectedChipIndex == i;

      items.add(
        GestureDetector(
          onTap: () =>
              setState(() => _selectedChipIndex = isSelected ? null : i),
          child: _CapsuleChip(
            label: email,
            isSelected: isSelected,
            onDelete: () => _removeEmail(i),
            style: widget.chipStyle,
          ),
        ),
      );
    }
    return items;
  }

  void _removeEmail(int index) {
    final current = List<String>.from(value ?? []);
    current.removeAt(index);
    if (_selectedChipIndex == index) _selectedChipIndex = null;
    didChange(current);
  }
}

class _CapsuleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onDelete;
  final EmailChipStyle style;

  const _CapsuleChip({
    required this.label,
    required this.isSelected,
    required this.onDelete,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? style.selectedColor ?? theme.primaryColor
        : style.backgroundColor ??
            (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05));

    final textColor = isSelected
        ? Colors.white
        : style.textColor ?? (isDark ? Colors.white70 : Colors.black87);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close,
                size: 14, color: textColor.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

/// Configuration for [EmailChipInput] chips.
class EmailChipStyle {
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final double borderRadius;

  const EmailChipStyle({
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.borderRadius = 8.0,
  });
}

class ChipEmailController extends ValueNotifier<List<String>> {
  ChipEmailController({List<String>? initialEmails})
      : super(initialEmails ?? []);
}
