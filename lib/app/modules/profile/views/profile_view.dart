import 'dart:io';

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
      body: SafeArea(child: ProfileContent()),
    );
  }
}

class ProfileContent extends GetView<ProfileController> {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(() {
        final ProfileModel profile =
            controller.profile.value ?? const ProfileModel.empty();
        return ColoredBox(
          color: AppColors.profileBackground,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                top: AppDimens.profileHeaderHeight,
                child:
                    controller.isLoading.value &&
                        controller.profile.value == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          AppDimens.screenHorizontalPadding,
                          AppDimens.profileAvatarSize / 2 + AppDimens.space12,
                          AppDimens.screenHorizontalPadding,
                          AppDimens.space24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              profile.displayedChildName,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.title.copyWith(
                                color: AppColors.profileTextDark,
                              ),
                            ),
                            const SizedBox(height: AppDimens.space24),
                            _ContactCard(profile: profile),
                            const SizedBox(height: AppDimens.space20),
                            _ProfileAction(
                              icon: Icons.share_outlined,
                              title: 'مشاركة التطبيق',
                              iconBackground: AppColors.lavender,
                              onTap: controller.shareApp,
                            ),
                            const SizedBox(height: AppDimens.space12),
                            _ProfileAction(
                              icon: Icons.star_outline_rounded,
                              title: 'تقييم التطبيق',
                              iconBackground: AppColors.softYellow,
                              onTap: () => _showRatingDialog(context),
                            ),
                            const SizedBox(height: AppDimens.space12),
                            _ProfileAction(
                              icon: Icons.language_rounded,
                              title: 'تغيير لغة التطبيق',
                              iconBackground: AppColors.softBlue,
                              onTap: controller.onChangeLanguage,
                            ),
                            const SizedBox(height: AppDimens.space12),
                            _ProfileAction(
                              icon: Icons.logout_rounded,
                              title: 'تسجيل الخروج',
                              iconBackground: AppColors.softPink,
                              onTap: controller.logout,
                              isDestructive: true,
                              isLoading: controller.isLoggingOut.value,
                            ),
                          ],
                        ),
                      ),
              ),
              const PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                child: _ProfileHeader(),
              ),
              PositionedDirectional(
                top:
                    AppDimens.profileHeaderHeight -
                    AppDimens.profileAvatarSize / 2,
                start: 0,
                end: 0,
                child: _ChildAvatar(
                  profile: profile,
                  isUpdating: controller.isUpdatingProfile.value,
                  onEditProfile: () => _showProfileEditor(context),
                ),
              ),
            ],
          ),
        );
      }),
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
        onPickFromGallery: controller.pickAvatarFromGallery,
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
    return ClipPath(
      clipper: const _ProfileHeaderClipper(),
      child: SizedBox(
        height: AppDimens.profileHeaderHeight,
        width: double.infinity,
        child: ColoredBox(
          color: AppColors.primaryDark,
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimens.space24),
              child: Text(
                'الملف الشخصي',
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderClipper extends CustomClipper<Path> {
  const _ProfileHeaderClipper();

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height * 0.78)
      ..cubicTo(
        size.width * 0.24,
        size.height * 1.02,
        size.width * 0.76,
        size.height * 1.02,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _ProfileHeaderClipper oldClipper) => false;
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
          Row(
            children: <Widget>[
              const _LeadingIcon(
                icon: Icons.contact_phone_outlined,
                background: AppColors.lavender,
              ),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Text(
                  'معلومات التواصل',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.profileTextDark,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimens.space16,
                color: AppColors.textMuted,
              ),
            ],
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

class _ChildAvatar extends StatelessWidget {
  const _ChildAvatar({
    required this.profile,
    required this.isUpdating,
    required this.onEditProfile,
  });

  final ProfileModel profile;
  final bool isUpdating;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: AppDimens.profileAvatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: AppDimens.profileAvatarSize,
              height: AppDimens.profileAvatarSize,
              padding: const EdgeInsets.all(AppDimens.space4),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image(
                  image: _avatarImageProvider(profile.avatarPath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(
                        color: AppColors.lavender,
                        child: Icon(
                          Icons.person_rounded,
                          size: AppDimens.space40,
                          color: AppColors.profilePrimary,
                        ),
                      ),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: AppDimens.profileAvatarEditOffset,
              end: AppDimens.profileAvatarEditOffset,
              child: Material(
                color: AppColors.primaryDark,
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
                    width: AppDimens.profileAvatarEditSize,
                    height: AppDimens.profileAvatarEditSize,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
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

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon, required this.background});

  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.buttonHeight,
      height: AppDimens.buttonHeight,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.profilePrimary),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.iconBackground,
    required this.onTap,
    this.isDestructive = false,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final Color iconBackground;
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
              _LeadingIcon(icon: icon, background: iconBackground),
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
    required this.onPickFromGallery,
  });

  final TextEditingController nameController;
  final String selectedAvatarPath;
  final Future<String?> Function() onPickFromGallery;

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
            OutlinedButton.icon(
              onPressed: () async {
                final String? path = await widget.onPickFromGallery();
                if (path != null && mounted) {
                  setState(() => _selectedAvatarPath = path);
                }
              },
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('اختيار من المعرض'),
            ),
            const SizedBox(height: AppDimens.space8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppDimens.space8,
              runSpacing: AppDimens.space8,
              children: <Widget>[
                if (_selectedAvatarPath.isNotEmpty &&
                    !ProfileController.avatarOptions.contains(
                      _selectedAvatarPath,
                    ))
                  CircleAvatar(
                    radius: AppDimens.space32,
                    backgroundColor: AppColors.profilePrimary,
                    child: CircleAvatar(
                      radius: AppDimens.space28,
                      backgroundImage: _avatarImageProvider(
                        _selectedAvatarPath,
                      ),
                    ),
                  ),
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
                        backgroundImage: _avatarImageProvider(path),
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

ImageProvider<Object> _avatarImageProvider(String path) {
  if (path.isEmpty) return const AssetImage(AppAssets.orchidSingle);
  if (path.startsWith('https://') || path.startsWith('http://')) {
    return NetworkImage(path);
  }
  if (path.startsWith('assets/')) return AssetImage(path);
  return FileImage(File(path));
}
