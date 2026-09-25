import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/color_constant.dart';

/// Circular avatar with an action badge, used at the top of the Edit Profile
/// screen where it overlaps the header wave.
///
/// Preview priority:
///  1. the photo the user just picked ([selectedImagePath])
///  2. the avatar already saved for the user ([existingImageUrl])
///  3. a neutral person icon as the final fallback
///
/// The badge follows the current state:
///  • empty avatar → green camera badge, tapping opens the picker
///  • any photo    → dark delete badge, tapping removes it (a photo that was
///                   already saved is deleted together with the next save)
///
/// With a photo on screen the circle itself stays tappable, which is how the
/// user picks a different one.
class ProfileAvatarPicker extends StatelessWidget {
  /// Local file path of the freshly picked photo — empty until the user picks.
  final String selectedImagePath;

  /// URL of the avatar already uploaded for this user — empty when there is
  /// none. A missing object simply falls back to the placeholder icon.
  final String existingImageUrl;

  /// Diameter of the avatar circle.
  final double size;

  /// Opens the camera / gallery bottom sheet.
  final VoidCallback onTap;

  /// Drops the photo that was picked but not uploaded yet.
  final VoidCallback onDelete;

  const ProfileAvatarPicker({
    super.key,
    required this.selectedImagePath,
    required this.existingImageUrl,
    required this.onTap,
    required this.onDelete,
    this.size = 116,
  });

  bool get _hasPickedFile => selectedImagePath.trim().isNotEmpty;
  bool get _hasStoredImage => existingImageUrl.trim().isNotEmpty;

  /// `true` whenever the circle shows a picture, no matter where it comes from.
  bool get _hasPhoto => _hasPickedFile || _hasStoredImage;

  @override
  Widget build(BuildContext context) {
    // The badge is allowed to hang slightly outside the circle, so the tappable
    // box is a little bigger than the avatar itself (8 px on both axes).
    const double badgeOverhang = 8;

    return SizedBox(
      width: size.w + badgeOverhang.w,
      height: size.h + badgeOverhang.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Tapping the circle always opens the picker for a new photo.
          // `opaque` makes the whole circle tappable — a plain deferToChild
          // detector would only react where the picture itself is hit-testable.
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: _avatar(),
            ),
          ),
          // The badge either opens the picker or removes the pending pick.
          Positioned(right: 0, bottom: 0, child: _actionBadge()),
        ],
      ),
    );
  }

  /// White ring + avatar preview.
  Widget _avatar() {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorConstant.blueLight,
        border: Border.all(color: ColorConstant.white, width: 4.w),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.inkMid.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(child: _preview()),
    );
  }

  /// Decides which image (if any) can be shown inside the circle.
  Widget _preview() {
    if (_hasPickedFile) {
      return Image.file(
        File(selectedImagePath),
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
      );
    }

    if (_hasStoredImage) {
      return Image.network(
        existingImageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        // Storage object missing / expired → keep the design intact instead of
        // showing a red error box.
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  /// Neutral avatar shown when no photo is available yet.
  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.person_rounded,
        size: 58.sp,
        color: ColorConstant.inkMid,
      ),
    );
  }

  /// Badge in the bottom-right corner of the avatar.
  ///
  /// Brand-green camera while the avatar is empty; dark themed delete button as
  /// soon as a photo is on screen (freshly picked or already saved).
  Widget _actionBadge() {
    final bool hasPhoto = _hasPhoto;

    return GestureDetector(
      // `opaque` so a tap anywhere on the 40 px badge counts, not only on the
      // glyph itself.
      behavior: HitTestBehavior.opaque,
      // Delete while there is something to remove, otherwise open the picker.
      onTap: hasPhoto ? onDelete : onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Theme gradients only: brand green for "add", dark navy for "remove".
          gradient: hasPhoto
              ? ColorConstant.darkGradient
              : ColorConstant.primaryGradient,
          border: Border.all(color: ColorConstant.white, width: 3.w),
        ),
        child: Icon(
          hasPhoto ? Icons.delete_outline_rounded : Icons.photo_camera_rounded,
          size: 17.sp,
          color: ColorConstant.white,
        ),
      ),
    );
  }
}
