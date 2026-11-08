import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      body: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('الملف الشخصي', style: AppTextStyles.h1),
          const SizedBox(height: AppDimens.space24),
          Container(
            padding: const EdgeInsets.all(AppDimens.space20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.softPink,
                  child: Icon(
                    Icons.face_rounded,
                    color: AppColors.primary,
                    size: 52,
                  ),
                ),
                SizedBox(height: AppDimens.space12),
                Text('ملف الطفل', style: AppTextStyles.title),
                SizedBox(height: AppDimens.space4),
                Text('إدارة الصورة والإعدادات', style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          const _ProfileOption(
            icon: Icons.face_retouching_natural_rounded,
            title: 'تخصيص الشخصية الكرتونية',
          ),
          const SizedBox(height: AppDimens.space12),
          const _ProfileOption(
            icon: Icons.settings_outlined,
            title: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Row(
            children: <Widget>[
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppDimens.space12),
              Expanded(child: Text(title, style: AppTextStyles.label)),
              const Icon(Icons.arrow_back_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
