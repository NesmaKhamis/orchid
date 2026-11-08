import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
=======

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';

class ProfileView extends StatelessWidget {
>>>>>>> 9b01b038e93a01f4ef6d11ec465397272b4be6f7
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('الملف الشخصي')),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final ProfileModel? profile = controller.profile.value;
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppDimens.screenHorizontalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'تعذر تحميل بيانات الملف الشخصي',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppDimens.space12),
                    TextButton(
                      onPressed: controller.loadProfile,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppDimens.screenHorizontalPadding,
              AppDimens.space16,
              AppDimens.screenHorizontalPadding,
              AppDimens.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _PersonalInfoCard(profile: profile),
                const SizedBox(height: AppDimens.space24),
                const _SectionHeading(
                  title: 'الدراسة والدرجات',
                  icon: Icons.school_outlined,
                ),
                const SizedBox(height: AppDimens.space12),
                _ProfileListCard(
                  title: 'الشهادة والدرجات',
                  icon: Icons.menu_book_outlined,
                  entries: profile.examResults,
                ),
                const SizedBox(height: AppDimens.space12),
                _ProfileListCard(
                  title: 'الواجبات',
                  icon: Icons.assignment_outlined,
                  entries: profile.assignments,
                ),
                const SizedBox(height: AppDimens.space12),
                _ProfileListCard(
                  title: 'جدول الحصص',
                  icon: Icons.calendar_month_outlined,
                  entries: profile.classSchedule,
                ),
                const SizedBox(height: AppDimens.space24),
                const _SectionHeading(
                  title: 'الإعدادات والتنبيهات',
                  icon: Icons.settings_outlined,
                ),
                const SizedBox(height: AppDimens.space12),
                _ProfileListCard(
                  title: 'التنبيهات',
                  icon: Icons.notifications_active_outlined,
                  entries: profile.notices,
                ),
                const SizedBox(height: AppDimens.space12),
                _SettingsCard(
                  onChangePassword: controller.onChangePassword,
                  onLogout: controller.logout,
                  isLoggingOut: controller.isLoggingOut.value,
                ),
              ],
            ),
          );
        }),
      ),
=======
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      body: const ProfileContent(),
>>>>>>> 9b01b038e93a01f4ef6d11ec465397272b4be6f7
    );
  }
}

<<<<<<< HEAD
class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: _cardDecoration(),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: AppDimens.space40,
            backgroundColor: AppColors.softPink,
            child: ClipOval(
              child: Image.asset(
                AppAssets.orchidSingle,
                width: AppDimens.space40 * 2,
                height: AppDimens.space40 * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          Text(profile.fullName, style: AppTextStyles.title),
          const SizedBox(height: AppDimens.space4),
          Text(profile.grade, style: AppTextStyles.body),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.space16),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _ContactRow(
            icon: Icons.phone_outlined,
            label: 'هاتف ولي الأمر',
            value: profile.parentPhone,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: AppDimens.space12),
          _ContactRow(
            icon: Icons.location_on_outlined,
            label: 'العنوان',
            value: profile.address,
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppDimens.space8),
        Expanded(child: Text(title, style: AppTextStyles.h2)),
      ],
    );
  }
}

class _ProfileListCard extends StatelessWidget {
  const _ProfileListCard({
    required this.title,
    required this.icon,
    required this.entries,
  });

  final String title;
  final IconData icon;
  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppDimens.space8),
              Expanded(child: Text(title, style: AppTextStyles.label)),
            ],
          ),
          const SizedBox(height: AppDimens.space12),
          for (int index = 0; index < entries.length; index++) ...<Widget>[
            if (index > 0) const SizedBox(height: AppDimens.space8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.circle,
                  size: AppDimens.space8,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimens.space8),
                Expanded(
                  child: Text(entries[index], style: AppTextStyles.body),
                ),
              ],
            ),
          ],
=======
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
>>>>>>> 9b01b038e93a01f4ef6d11ec465397272b4be6f7
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.textDirection,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppDimens.space8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: AppTextStyles.caption),
              Text(
                value,
                textDirection: textDirection,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.onChangePassword,
    required this.onLogout,
    required this.isLoggingOut,
  });

  final VoidCallback onChangePassword;
  final VoidCallback onLogout;
  final bool isLoggingOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: _cardDecoration(),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onChangePassword,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.space8),
              child: Row(
                children: <Widget>[
                  Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                  SizedBox(width: AppDimens.space8),
                  Expanded(
                    child: Text(
                      'تغيير كلمة المرور',
                      style: AppTextStyles.label,
                    ),
                  ),
                  Icon(Icons.arrow_back_ios_rounded, size: AppDimens.space16),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoggingOut ? null : onLogout,
              icon: isLoggingOut
                  ? const SizedBox.square(
                      dimension: AppDimens.space20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.logout_rounded),
              label: const Text('تسجيل الخروج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                ),
                textStyle: AppTextStyles.label,
              ),
            ),
          ),
        ],
=======
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
>>>>>>> 9b01b038e93a01f4ef6d11ec465397272b4be6f7
      ),
    );
  }
}
<<<<<<< HEAD

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
    border: Border.all(color: AppColors.border),
  );
}
=======
>>>>>>> 9b01b038e93a01f4ef6d11ec465397272b4be6f7
