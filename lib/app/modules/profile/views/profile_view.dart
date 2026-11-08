import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.profileBackground,
      body: ProfileContent(),
    );
  }
}

class ProfileContent extends GetView<ProfileController> {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: AppColors.profileBackground,
        child: Obx(() {
          final ProfileModel profile =
              controller.profile.value ?? const ProfileModel.empty();
          return SafeArea(
            child: Column(
              children: <Widget>[
                const _ProfileHeader(),
                Expanded(
                  child:
                      controller.isLoading.value &&
                          controller.profile.value == null
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            AppDimens.screenHorizontalPadding,
                            AppDimens.space12,
                            AppDimens.screenHorizontalPadding,
                            AppDimens.space24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _ChildIdentity(
                                profile: profile,
                                isUpdating: controller.isUpdatingProfile.value,
                                onEditProfile: () => _showProfileEditor(context),
                              ),
                              const SizedBox(height: AppDimens.space20),
                              _ContactCard(profile: profile),
                              const SizedBox(height: AppDimens.space20),
                              _ProfileAction(
                                icon: Icons.share_outlined,
                                title: 'مشاركة التطبيق',
                                onTap: controller.shareApp,
                              ),
                              const SizedBox(height: AppDimens.space12),
                              _ProfileAction(
                                icon: Icons.star_outline_rounded,
                                title: 'تقييم التطبيق',
                                onTap: () => _showRatingDialog(context),
                              ),
                              const SizedBox(height: AppDimens.space12),
                              _ProfileAction(
                                icon: Icons.language_rounded,
                                title: 'تغيير لغة التطبيق',
                                onTap: controller.onChangeLanguage,
                              ),
                              const SizedBox(height: AppDimens.space12),
                              _ProfileAction(
                                icon: Icons.logout_rounded,
                                title: 'تسجيل الخروج',
                                onTap: controller.logout,
                                isDestructive: true,
                                isLoading: controller.isLoggingOut.value,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _showRatingDialog(BuildContext context) async {
    final int? rating = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => const _RatingDialog(),
    );
    if (rating != null) controller.submitRating(rating);
  }

  Future<void> _showProfileEditor(BuildContext context) async {
    controller.childNameController.text =
        controller.profile.value?.childName ?? '';
    final _ProfileEditResult? result = await showDialog<_ProfileEditResult>(
      context: context,
      builder: (BuildContext context) => _ProfileEditDialog(
        nameController: controller.childNameController,
        selectedAvatarPath: controller.profile.value?.avatarPath ?? '',
      ),
    );
    if (result == null) return;

    final ProfileModel currentProfile =
        controller.profile.value ?? const ProfileModel.empty();
    if (result.name != currentProfile.childName) {
      await controller.updateChildName(result.name);
    }
    if (result.avatarPath != currentProfile.avatarPath) {
      await controller.updateAvatarPath(result.avatarPath);
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: const BoxDecoration(
        color: AppColors.profilePrimary,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(AppDimens.radiusCard),
          bottomEnd: Radius.circular(AppDimens.radiusCard),
        ),
      ),
      child: Text(
        'الملف الشخصي',
        textAlign: TextAlign.center,
        style: AppTextStyles.h2.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'معلومات التواصل',
            style: AppTextStyles.title.copyWith(
              color: AppColors.profileTextDark,
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          _ContactRow(
            icon: Icons.phone_outlined,
            label: 'رقم الهاتف',
            value: profile.displayedPhoneNumber,
            textDirection: profile.phoneNumber.isEmpty
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.space16),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _ContactRow(
            icon: Icons.location_on_outlined,
            label: 'العنوان',
            value: profile.displayedAddress,
          ),
        ],
      ),
    );
  }
}

class _ChildIdentity extends StatelessWidget {
  const _ChildIdentity({
    required this.profile,
    required this.isUpdating,
    required this.onEditProfile,
  });

  final ProfileModel profile;
  final bool isUpdating;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final String imagePath = profile.avatarPath;
    final bool isNetworkImage =
        imagePath.startsWith('https://') || imagePath.startsWith('http://');
    final ImageProvider<Object> imageProvider = imagePath.isEmpty
        ? const AssetImage(AppAssets.orchidSingle)
        : isNetworkImage
        ? NetworkImage(imagePath)
        : AssetImage(imagePath);

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: isUpdating ? null : onEditProfile,
          child: SizedBox.square(
            dimension: AppDimens.space40 * 2,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                CircleAvatar(
                  radius: AppDimens.space40,
                  backgroundColor: AppColors.lavender,
                  child: ClipOval(
                    child: Image(
                      image: imageProvider,
                      width: AppDimens.space40 * 2,
                      height: AppDimens.space40 * 2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                            Icons.person_rounded,
                            size: AppDimens.space40,
                            color: AppColors.profilePrimary,
                          ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppDimens.profileAvatarEditInset,
                  right: AppDimens.profileAvatarEditInset,
                  child: Material(
                    color: AppColors.profilePrimary,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: isUpdating ? null : onEditProfile,
                      tooltip: 'تعديل بيانات الطفل',
                      icon: const Icon(
                        Icons.edit_rounded,
                        size: AppDimens.space12,
                        color: AppColors.white,
                      ),
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimens.space24,
                        height: AppDimens.space24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimens.space12),
        InkWell(
          onTap: isUpdating ? null : onEditProfile,
          borderRadius: BorderRadius.circular(AppDimens.radiusChip),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppDimens.space8,
              vertical: AppDimens.space4,
            ),
            child: Text(
              profile.displayedChildName,
              style: AppTextStyles.title.copyWith(
                color: AppColors.profileTextDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
        Icon(icon, color: AppColors.profilePrimary),
        const SizedBox(width: AppDimens.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppDimens.space4),
              Text(
                value,
                textDirection: textDirection,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.profileTextDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isDestructive
        ? AppColors.error
        : AppColors.profilePrimary;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.space16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: foreground),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    color: isDestructive
                        ? AppColors.error
                        : AppColors.profileTextDark,
                  ),
                ),
              ),
              if (isLoading)
                SizedBox.square(
                  dimension: AppDimens.space20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              else
                Icon(
                  Icons.arrow_back_ios_rounded,
                  size: AppDimens.space16,
                  color: foreground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog();

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.profileBackground,
      title: const Text('قيّم تطبيق أوركيد'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(5, (int index) {
          final int value = index + 1;
          return IconButton(
            onPressed: () => setState(() => _rating = value),
            color: AppColors.profilePrimary,
            icon: Icon(
              value <= _rating
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
            ),
          );
        }),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: _rating == 0
              ? null
              : () => Navigator.of(context).pop(_rating),
          child: const Text('إرسال'),
        ),
      ],
    );
  }
}

typedef _ProfileEditResult = ({String name, String avatarPath});

class _ProfileEditDialog extends StatefulWidget {
  const _ProfileEditDialog({
    required this.nameController,
    required this.selectedAvatarPath,
  });

  final TextEditingController nameController;
  final String selectedAvatarPath;

  @override
  State<_ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<_ProfileEditDialog> {
  late String _selectedAvatarPath = widget.selectedAvatarPath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.profileBackground,
      title: const Text('تعديل بيانات الطفل'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: widget.nameController,
              autofocus: true,
              textDirection: TextDirection.rtl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'اسم الطفل'),
            ),
            const SizedBox(height: AppDimens.space16),
            const Text('اختر صورة'),
            const SizedBox(height: AppDimens.space8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppDimens.space8,
              runSpacing: AppDimens.space8,
              children: <Widget>[
                for (final String path in ProfileController.avatarOptions)
                  InkWell(
                    onTap: () => setState(() => _selectedAvatarPath = path),
                    borderRadius: BorderRadius.circular(AppDimens.space40),
                    child: CircleAvatar(
                      radius: AppDimens.space32,
                      backgroundColor: path == _selectedAvatarPath
                          ? AppColors.profilePrimary
                          : AppColors.lavender,
                      child: CircleAvatar(
                        radius: AppDimens.space28,
                        backgroundImage: AssetImage(path),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: widget.nameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop((
                  name: widget.nameController.text.trim(),
                  avatarPath: _selectedAvatarPath,
                )),
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
