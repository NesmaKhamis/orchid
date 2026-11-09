import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Shows a dialog requesting the parent to solve a simple math problem
/// before confirming a child action (e.g. redeeming a reward).
Future<bool> showParentGateDialog(BuildContext context) async {
  final bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => const ParentGateDialog(),
  );
  return result ?? false;
}

class ParentGateDialog extends StatefulWidget {
  const ParentGateDialog({super.key});

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  late final int _num1;
  late final int _num2;
  late final int _expectedAnswer;
  final TextEditingController _answerController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final Random random = Random();
    // Use numbers between 14 and 39 so it's simple for parents but tricky for 5-12 kids.
    _num1 = 15 + random.nextInt(20);
    _num2 = 12 + random.nextInt(25);
    _expectedAnswer = _num1 + _num2;
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _verifyAndSubmit() {
    final String text = _answerController.text.trim();
    final int? entered = int.tryParse(text);
    if (entered == _expectedAnswer) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _errorMessage = 'الإجابة غير صحيحة، يرجى المحاولة مرة أخرى';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.screenHorizontalPadding,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              // Header icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.space12),
                  decoration: const BoxDecoration(
                    color: AppColors.lavender,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space16),
              // Title
              const Text(
                'بوابة الوالدين',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.space8),
              Text(
                'لحماية طفلك، يرجى من ولي الأمر حل المسألة الحسابية لتأكيد طلب المكافأة:',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSubtitle,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.space20),
              // Math Problem
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.space12,
                  horizontal: AppDimens.space16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(AppDimens.radiusField),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    '$_num1 + $_num2 = ?',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space16),
              // Input field
              TextField(
                controller: _answerController,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: AppTextStyles.title,
                decoration: InputDecoration(
                  hintText: 'اكتب الناتج هنا',
                  hintStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppDimens.space12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusField),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusField),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusField),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) => _verifyAndSubmit(),
              ),
              if (_errorMessage != null) ...<Widget>[
                const SizedBox(height: AppDimens.space8),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppDimens.space24),
              // Actions
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      label: 'إلغاء',
                      variant: AppButtonVariant.soft,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: AppDimens.space12),
                  Expanded(
                    child: AppButton(
                      label: 'تأكيد',
                      variant: AppButtonVariant.primary,
                      onPressed: _verifyAndSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
