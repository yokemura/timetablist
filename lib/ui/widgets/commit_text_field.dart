import 'package:flutter/material.dart';

/// Text field that commits on Enter or focus loss, never per keystroke.
///
/// Validation errors are shown while typing, but [onCommit] is only called
/// with a valid, changed value. Losing focus with invalid input reverts the
/// text to the last committed [value] instead of committing.
class CommitTextField extends StatefulWidget {
  const CommitTextField({
    required this.value,
    required this.onCommit,
    this.validator,
    this.label,
    this.hintText,
    this.enabled = true,
    this.keyboardType,
    super.key,
  });

  /// Last committed value. The field reverts to this on invalid unfocus.
  final String value;

  final ValueChanged<String> onCommit;

  /// Returns a localized error message, or null when [value] is acceptable.
  final String? Function(String value)? validator;

  final String? label;
  final String? hintText;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  State<CommitTextField> createState() => _CommitTextFieldState();
}

class _CommitTextFieldState extends State<CommitTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  /// Guards against double commits: pressing Enter both submits and drops
  /// focus, and the parent may not have rebuilt with the new value yet.
  late String _lastCommitted = widget.value;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CommitTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _lastCommitted = widget.value;
      // Reflect external value changes unless the user is editing right now.
      if (!_focusNode.hasFocus) {
        _controller.text = widget.value;
        _errorText = null;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) return;
    final text = _controller.text;
    if (_validate(text) != null) {
      // Invalid input is never committed; restore the committed value.
      setState(() {
        _controller.text = _lastCommitted;
        _errorText = null;
      });
      return;
    }
    _commit(text);
  }

  void _handleSubmitted(String text) {
    final error = _validate(text);
    if (error != null) {
      // Nothing is committed. If Enter also drops focus, the focus handler
      // reverts the text; otherwise the error stays visible for fixing.
      setState(() => _errorText = error);
      return;
    }
    _commit(text);
  }

  void _commit(String text) {
    setState(() => _errorText = null);
    if (text != _lastCommitted) {
      _lastCommitted = text;
      widget.onCommit(text);
    }
  }

  String? _validate(String text) => widget.validator?.call(text);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      onChanged: (text) => setState(() => _errorText = _validate(text)),
      onSubmitted: _handleSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        errorText: _errorText,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
