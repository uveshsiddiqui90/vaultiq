import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/core/config/app_config.dart';

/// About App screen — opened from the "About App" row of the Profile tab.
///
/// Layout, top → bottom:
///  1. gradient header (the same dark navy → teal used by Profile, Edit Profile
///     and Change Password) with the round back button, the app title, the
///     "Simple. Smart. Secure." line and a wallet badge on the right
///  2. a white card that rises into the header with the app identity, the short
///     description, the "What you can do" feature list, the version pill and
///     the closing note
///  3. a soft mint wave fixed at the bottom of the screen
///
/// The screen only presents information, so it owns no state and needs no
/// controller — every feature row opens the details bottom sheet built in
/// [_DetailsSheet].
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  /// How far the content card rises into the header.
  static const double _cardOverlap = 26;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Stack(
        children: [
          _backgroundWave(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _header(context),

                // Pulls the card up over the header so the two areas feel
                // joined instead of leaving a visible seam between them.
                Transform.translate(
                  offset: Offset(0, -_cardOverlap.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _contentCard(),
                  ),
                ),

                // Breathing room under the card, matching the space the overlap
                // consumed above.
                SizedBox(height: 18.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // HEADER
  // ──────────────────────────────────────────────────────────
  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20.w,
        // The gradient runs behind the status bar like the other profile
        // screens, so the inset is added as padding instead of using SafeArea.
        MediaQuery.paddingOf(context).top + 14.h,
        20.w,
        // Room for the part of the card that overlaps the header.
        44.h,
      ),
      decoration: BoxDecoration(
        gradient: ColorConstant.profileHeaderGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _backButton(context),
          AppSize.h16,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TextConstant.aboutApp,
                      style: AppStyles.syne(
                        size: AppTextSize.largeTitle,
                        weight: AppFontWeight.bold,
                        color: ColorConstant.white,
                      ),
                    ),
                    AppSize.h6,
                    Text(
                      TextConstant.aboutAppSubtitle,
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.medium,
                        color: ColorConstant.white.withValues(alpha: 0.70),
                      ),
                    ),
                    AppSize.h2,
                    Text(
                      TextConstant.aboutAppTagline,
                      style: AppStyles.dmSans(
                        size: 11.5.sp,
                        weight: AppFontWeight.regular,
                        color: ColorConstant.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              AppSize.w12,
              _walletBadge(),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // CONTENT CARD
  // ──────────────────────────────────────────────────────────
  Widget _contentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.inkDark.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appIdentity(),
          SizedBox(height: 18.h),
          _descriptionPanel(),
          SizedBox(height: 22.h),

          // Section label followed by one row per capability. The rows are
          // separated by hairlines instead of being boxed, so the card reads as
          // one list rather than four separate cards.
          Text(
            TextConstant.aboutWhatYouCanDo,
            style: AppStyles.syne(
              size: 15.sp,
              weight: AppFontWeight.bold,
              color: ColorConstant.inkDark,
            ),
          ),
          SizedBox(height: 6.h),
          ..._featureTiles(),

          SizedBox(height: 18.h),
          _versionPill(),
          SizedBox(height: 18.h),
          _builtWithLoveNote(),
        ],
      ),
    );
  }

  /// App identity block: gradient logo tile, the two-tone "VaultIQ" wordmark and
  /// the product tagline.
  Widget _appIdentity() {
    return Row(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            gradient: ColorConstant.primaryGradient,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: ColorConstant.primary.withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.trending_up_rounded,
            size: 27.sp,
            color: ColorConstant.white,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Two-tone wordmark: the "IQ" keeps the brand mint accent.
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vault',
                      style: AppStyles.syne(
                        size: 24.sp,
                        weight: AppFontWeight.extraBold,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                    TextSpan(
                      text: 'IQ',
                      style: AppStyles.syne(
                        size: 24.sp,
                        weight: AppFontWeight.extraBold,
                        color: ColorConstant.primaryDark,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h),
              Text(
                TextConstant.aboutAppNameTagline,
                style: AppStyles.dmSans(
                  size: 11.5.sp,
                  weight: AppFontWeight.medium,
                  color: ColorConstant.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// What the app is, in one short paragraph, on the mint surface used by the
  /// reassurance banners of the other profile screens.
  Widget _descriptionPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorConstant.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        TextConstant.aboutAppDescription,
        style: AppStyles.dmSans(
          size: 12.sp,
          weight: AppFontWeight.regular,
          color: ColorConstant.inkMid,
        ).copyWith(height: 1.6),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // FEATURE LIST
  // ──────────────────────────────────────────────────────────

  /// One [_featureTile] per capability, with a hairline between them.
  List<Widget> _featureTiles() {
    final List<Widget> tiles = <Widget>[];

    for (int i = 0; i < _features.length; i++) {
      if (i > 0) {
        tiles.add(
          Divider(height: 16.h, thickness: 1, color: ColorConstant.border),
        );
      }

      tiles.add(_featureTile(_features[i]));
    }

    return tiles;
  }

  /// One capability row: coloured icon disc, title, one-line summary and a
  /// chevron. Tapping it opens the matching details sheet.
  Widget _featureTile(_AboutFeature feature) {
    return InkWell(
      onTap: () => _openFeatureSheet(feature),
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: feature.background,
              ),
              child: Icon(feature.icon, size: 21.sp, color: feature.iconColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: AppStyles.dmSans(
                      size: 13.5.sp,
                      weight: AppFontWeight.bold,
                      color: ColorConstant.inkDark,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    feature.summary,
                    style: AppStyles.dmSans(
                      size: 11.5.sp,
                      weight: AppFontWeight.regular,
                      color: ColorConstant.inkMuted,
                    ).copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.sp,
              color: ColorConstant.inkMuted.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the details sheet of [feature] from the bottom of the screen.
  void _openFeatureSheet(_AboutFeature feature) {
    Get.bottomSheet(
      _DetailsSheet(feature: feature),
      backgroundColor: Colors.transparent,
      // The sheet sizes itself to its content, which can be taller than the
      // default 9/16 of the screen for the longer descriptions.
      isScrollControlled: true,
    );
  }

  // ──────────────────────────────────────────────────────────
  // FOOTER
  // ──────────────────────────────────────────────────────────

  /// Small grey pill with the app version — read from [AppConfig] so it can
  /// never drift away from the real build.
  Widget _versionPill() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorConstant.bgLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15.sp,
            color: ColorConstant.inkMuted,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '${TextConstant.aboutVersionPrefix} ${AppConfig.appVersion}',
              style: AppStyles.dmSans(
                size: 11.5.sp,
                weight: AppFontWeight.semiBold,
                color: ColorConstant.inkMid,
              ),
            ),
          ),
          Text(
            AppConfig.appName,
            style: AppStyles.syne(
              size: 12.sp,
              weight: AppFontWeight.bold,
              color: ColorConstant.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  /// Closing note: green heart disc, the "built with love" line and the
  /// thank-you copy — same surface as the reassurance banners of the other
  /// profile screens.
  Widget _builtWithLoveNote() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorConstant.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: ColorConstant.primaryGradient,
            ),
            child: Icon(
              Icons.favorite_rounded,
              size: 18.sp,
              color: ColorConstant.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConstant.aboutFooterTitle,
                  style: AppStyles.dmSans(
                    size: 13.sp,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  TextConstant.aboutFooterDesc,
                  style: AppStyles.dmSans(
                    size: 11.5.sp,
                    weight: AppFontWeight.regular,
                    color: ColorConstant.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.eco_rounded, size: 20.sp, color: ColorConstant.primary),
        ],
      ),
    );
  }

  /// Round, translucent back button — the same one the Edit Profile and Change
  /// Password headers use.
  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstant.white.withValues(alpha: 0.12),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 15.sp,
          color: ColorConstant.white,
        ),
      ),
    );
  }

  /// Header cue: a translucent wallet disc with a small amber rupee coin, so the
  /// screen reads as "money app" without pulling in an illustration asset.
  Widget _walletBadge() {
    return SizedBox(
      width: 62.w,
      height: 62.w,
      child: Stack(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstant.white.withValues(alpha: 0.10),
              border: Border.all(
                color: ColorConstant.white.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 27.sp,
              color: ColorConstant.white.withValues(alpha: 0.92),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 23.w,
              height: 23.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.amber,
              ),
              child: Center(
                child: Text(
                  AppConfig.currencySymbol,
                  style: AppStyles.dmSans(
                    size: 13.sp,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Soft mint wave pinned to the bottom of the screen, behind the card.
  Widget _backgroundWave() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: ClipPath(
          clipper: const _BottomWaveClipper(),
          child: Container(
            height: 130.h,
            color: ColorConstant.primaryLight.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

/// Wavy top edge for the decorative mint band at the bottom of the screen —
/// the same shape the Edit Profile screen uses.
class _BottomWaveClipper extends CustomClipper<Path> {
  const _BottomWaveClipper();

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

/// One capability shown in the "What you can do" list.
///
/// [summary] is the copy of the row itself, [details] and [points] fill the
/// bottom sheet that opens when the row is tapped.
class _AboutFeature {
  final IconData icon;
  final String title;
  final String summary;
  final String details;
  final List<String> points;
  final Color iconColor;
  final Color background;

  const _AboutFeature({
    required this.icon,
    required this.title,
    required this.summary,
    required this.details,
    required this.points,
    required this.iconColor,
    required this.background,
  });
}

/// The app's four capabilities, in the order they appear on the card. Icon
/// tints reuse the palette the Profile and Analytics screens already use.
const List<_AboutFeature> _features = [
  _AboutFeature(
    icon: Icons.trending_up_rounded,
    title: TextConstant.aboutTrackExpenses,
    summary: TextConstant.aboutTrackExpensesSummary,
    details: TextConstant.aboutTrackExpensesDetails,
    points: TextConstant.aboutTrackExpensesPoints,
    iconColor: ColorConstant.primaryDark,
    background: ColorConstant.primaryLight,
  ),
  _AboutFeature(
    icon: Icons.account_balance_wallet_rounded,
    title: TextConstant.aboutSetBudgets,
    summary: TextConstant.aboutSetBudgetsSummary,
    details: TextConstant.aboutSetBudgetsDetails,
    points: TextConstant.aboutSetBudgetsPoints,
    iconColor: ColorConstant.blue,
    background: ColorConstant.blueLight,
  ),
  _AboutFeature(
    icon: Icons.pie_chart_outline_rounded,
    title: TextConstant.aboutGetInsights,
    summary: TextConstant.aboutGetInsightsSummary,
    details: TextConstant.aboutGetInsightsDetails,
    points: TextConstant.aboutGetInsightsPoints,
    iconColor: ColorConstant.purple,
    background: ColorConstant.purpleLight,
  ),
  _AboutFeature(
    icon: Icons.verified_user_rounded,
    title: TextConstant.aboutDataPriority,
    summary: TextConstant.aboutDataPrioritySummary,
    details: TextConstant.aboutDataPriorityDetails,
    points: TextConstant.aboutDataPriorityPoints,
    iconColor: ColorConstant.amber,
    background: ColorConstant.amberLight,
  ),
];

/// Bottom sheet with the full explanation of one capability: colour-matched
/// icon, title, description and the bullet points of what the user gets.
class _DetailsSheet extends StatelessWidget {
  final _AboutFeature feature;

  const _DetailsSheet({required this.feature});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        // The sheet grows with its content but never past most of the screen;
        // anything taller (long copy, big text settings) scrolls inside it
        // instead of overflowing.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle.
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ColorConstant.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: feature.background,
                    ),
                    child: Icon(
                      feature.icon,
                      size: 22.sp,
                      color: feature.iconColor,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      feature.title,
                      style: AppStyles.syne(
                        size: 18.sp,
                        weight: AppFontWeight.bold,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                feature.details,
                style: AppStyles.dmSans(
                  size: 12.5.sp,
                  weight: AppFontWeight.regular,
                  color: ColorConstant.inkMid,
                ).copyWith(height: 1.6),
              ),
              SizedBox(height: 16.h),
              ...feature.points.map(_point),
            ],
          ),
        ),
      ),
    );
  }

  /// One green-ticked highlight line of the sheet.
  Widget _point(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 15.sp,
            color: ColorConstant.primaryDark,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: AppStyles.dmSans(
                size: 12.sp,
                weight: AppFontWeight.regular,
                color: ColorConstant.inkMid,
              ).copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
