import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_utils/image_picker_bottomsheet/image_picker_bottomsheet.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/edit_profile_controller/edit_profile_controller_v2.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/widget/edit_profile_footer.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/widget/edit_profile_header.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/widget/profile_avatar_picker.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/widget/profile_info_field.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/widget/secure_profile_banner.dart';

/// Edit Profile screen.
///
/// Layout, top → bottom (exactly like the design mock-up):
///  1. [EditProfileHeader]    — gradient bar whose bottom edge is a wave
///  2. [ProfileAvatarPicker]  — avatar straddling that wave
///  3. the personal information card (name + email + security note)
///  4. the "Save Changes" button — it also uploads a newly picked photo and
///     deletes a photo the user removed with the badge
///  5. [EditProfileFooter]    — closing motivational note
///
/// A single `Obx` wraps the scrolling body because the avatar and the button
/// react to the controller's Rx state (picked file, stored avatar and the busy
/// flags).
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  /// Created once for this screen and reused on every rebuild.
  final EditProfileControllerV2 editProfileController = Get.put(
    EditProfileControllerV2(),
  );

  /// Vertical room the header keeps free for the overlapping avatar.
  static const double _headerReserve = 64;

  /// Vertical room reserved for the part of the avatar that hangs over the
  /// wave: half of its 116 height plus the 8 px badge overhang, so the circle
  /// ends up centred exactly on the header's bottom edge.
  static const double _avatarOverhang = 66;

  @override
  void initState() {
    super.initState();
    // The controller is not tied to a GetX binding, so it can outlive this
    // route. Re-syncing here guarantees the fields always show the values that
    // are stored right now (e.g. after saving a new name and coming back).
    editProfileController.loadForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: Stack(
        children: [
          _backgroundWave(),
          Obx(
            () => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _headerWithAvatar(context),
                  _infoCard(),
                  SizedBox(height: 24.h),
                  _actionButtons(),
                  SizedBox(height: 30.h),
                  const EditProfileFooter(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // HEADER + AVATAR OVERLAP
  // ──────────────────────────────────────────────────────────

  /// Header with the avatar floating half over its wave.
  ///
  /// The `Stack` is deliberately taller than the header: the extra room below
  /// keeps the avatar *inside* the box while it still hangs over the wave.
  /// Flutter only hit-tests children that sit inside their parent's box, so a
  /// negative `bottom` offset painted the avatar fine but swallowed every tap
  /// on it (the badge looked fine and did nothing).
  Widget _headerWithAvatar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            EditProfileHeader(
              onBack: () => Get.back(),
              bottomSpace: _headerReserve,
            ),
            // Room where the lower half of the avatar sits.
            SizedBox(height: _avatarOverhang.h),
          ],
        ),
        // `bottom: 0` keeps the whole avatar — and its badge — inside the
        // Stack, so both the circle and the badge stay tappable.
        Positioned(
          bottom: 0,
          child: ProfileAvatarPicker(
            selectedImagePath: editProfileController.selectedImagePath.value,
            existingImageUrl: editProfileController.existingImageUrl.value,
            onTap: () => _openImagePicker(context),
            // Delete badge on the avatar → removes the photo (a saved one is
            // deleted from storage together with the next save).
            onDelete: editProfileController.removeProfileImage,
          ),
        ),
      ],
    );
  }

  /// Opens the camera / gallery chooser for the avatar.
  void _openImagePicker(BuildContext context) {
    ImagePickerBottomSheet.show(
      context: context,
      onCameraTap: editProfileController.pickImageFromCamera,
      onGalleryTap: editProfileController.pickImageFromGallery,
    );
  }

  // ──────────────────────────────────────────────────────────
  // PERSONAL INFORMATION CARD
  // ──────────────────────────────────────────────────────────

  /// White card holding the name field, the read-only email field and the
  /// "your profile is secure" note.
  Widget _infoCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: ColorConstant.border),
          boxShadow: [
            BoxShadow(
              color: ColorConstant.inkMid.withValues(alpha: 0.07),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Editable full name.
            ProfileInfoField(
              icon: Icons.person_outline_rounded,
              iconColor: ColorConstant.primaryDark,
              iconBackgroundColor: ColorConstant.primaryLight,
              label: TextConstant.fullNameLabel,
              hint: TextConstant.enterFullNameHint,
              controller: editProfileController.nameController,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 18.h),

            // Email comes from the signed-in account, so it is read-only.
            ProfileInfoField(
              icon: Icons.mail_outline_rounded,
              iconColor: ColorConstant.blue,
              iconBackgroundColor: ColorConstant.blueLight,
              label: TextConstant.emailAddressLabel,
              controller: editProfileController.emailController,
              // The email belongs to the account → row stays disabled.
              enabled: false,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 18.h),

            // Reassurance card shown directly under the fields.
            const SecureProfileBanner(),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // ACTIONS
  // ──────────────────────────────────────────────────────────

  /// Single "Save Changes" action.
  ///
  /// The photo is no longer uploaded by its own button: this one button uploads
  /// a freshly picked photo, deletes a removed one and saves the name (see
  /// [EditProfileControllerV2.saveChanges]).
  Widget _actionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomButton(
        label: TextConstant.saveChanges,
        radius: 30.r,
        // Spins while the photo upload, the photo deletion or the name update
        // is running.
        isLoading: editProfileController.isLoading,
        onPressed: editProfileController.saveChanges,
        // Primary variant = the app's green gradient, so the one action on this
        // screen uses the theme colour.
        prefixIcon: Icon(
          Icons.edit_outlined,
          size: 19.sp,
          color: ColorConstant.white,
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // DECORATION
  // ──────────────────────────────────────────────────────────

  /// Soft mint wave pinned to the bottom of the screen (behind the footer).
  Widget _backgroundWave() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipPath(
        clipper: _BottomWaveClipper(),
        child: Container(
          height: 130.h,
          color: ColorConstant.primaryLight.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

/// Wavy top edge for the decorative mint band at the bottom of the screen.
class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height * 0.45)
      // long, shallow curve across the middle
      ..quadraticBezierTo(
        size.width * 0.25,
        0,
        size.width * 0.55,
        size.height * 0.30,
      )
      // small secondary bump before the right edge
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.62,
        size.width,
        size.height * 0.25,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
