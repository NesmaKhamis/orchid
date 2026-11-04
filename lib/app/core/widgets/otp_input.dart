import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Controls an [OtpInput] from a GetX controller without owning a BuildContext.
class OtpInputController {
  VoidCallback? _clearCallback;

  void clear() {
    _clearCallback?.call();
  }
}

/// N separate digit boxes.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final OtpInputController? controller;
  final bool autofocus;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = <TextEditingController>[];
  final List<FocusNode> _focusNodes = <FocusNode>[];
  String _code = '';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    widget.controller?._clearCallback = _clear;
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._clearCallback = null;
      widget.controller?._clearCallback = _clear;
    }
  }

  @override
  void dispose() {
    widget.controller?._clearCallback = null;
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _clear() {
    for (final TextEditingController controller in _controllers) {
      controller.clear();
    }
    _code = '';
    widget.onChanged?.call(_code);
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
  }

  void _onChanged(int index, String value) {
    final String digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 1) {
      for (final TextEditingController controller in _controllers) {
        controller.clear();
      }
      for (int i = 0; i < digits.length && index + i < widget.length; i++) {
        _controllers[index + i].text = digits[i];
      }
      final int lastIndex = (index + digits.length - 1).clamp(
        0,
        widget.length - 1,
      );
      _focusNodes[lastIndex].requestFocus();
      _syncCode();
      return;
    }

    if (digits.isEmpty) {
      _controllers[index].clear();
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      _syncCode();
      return;
    }

    _controllers[index].value = TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _syncCode();
  }

  void _syncCode() {
    _code = _controllers.map((TextEditingController c) => c.text).join();
    widget.onChanged?.call(_code);
    if (_code.length == widget.length) {
      widget.onCompleted?.call(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(widget.length, (int index) {
          return Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onKeyEvent: (FocusNode node, KeyEvent event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _focusNodes[index - 1].requestFocus();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: SizedBox(
              width: 48,
              height: 56,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: widget.autofocus && index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: AppTextStyles.title,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: AppColors.inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusField),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusField),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusField),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onChanged: (String value) => _onChanged(index, value),
              ),
            ),
          );
        }),
      ),
    );
  }
}
