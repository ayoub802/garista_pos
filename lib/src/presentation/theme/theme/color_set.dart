part of 'theme.dart';

class CustomColorSet {
  final Color primary;

  final Color white;

  final Color textHint;

  final Color textBlack;

  final Color textWhite;

  final Color icon;

  final Color success;

  final Color error;

  final Color transparent;

  final Color backgroundColor;

  final Color socialButtonColor;

  final Color newBoxColor;

  final Color bottomBarColor;

  final Color categoryColor;

  final Color categoryTitleColor;

  CustomColorSet._({
    required this.textHint,
    required this.textBlack,
    required this.textWhite,
    required this.primary,
    required this.white,
    required this.icon,
    required this.success,
    required this.error,
    required this.transparent,
    required this.backgroundColor,
    required this.socialButtonColor,
    required this.bottomBarColor,
    required this.categoryColor,
    required this.categoryTitleColor,
    required this.newBoxColor,
  });

  factory CustomColorSet._create(CustomThemeMode mode) {
    final isLight = mode.isLight;

    final textHint = isLight ? AppColors.hintColor : AppColors.white;

    final textBlack = isLight ? AppColors.black : AppColors.white;

    final textWhite = isLight ? AppColors.white : AppColors.black;

    final categoryColor = isLight ? AppColors.black : AppColors.iconButtonBack;

    final categoryTitleColor = isLight ? AppColors.black : AppColors.white;

    const primary = AppColors.brandColor;

    const white = AppColors.white;

    const icon = AppColors.iconColor;

    final backgroundColor = isLight ? AppColors.mainBack : AppColors.iconButtonBack;

    final newBoxColor = isLight ? AppColors.iconColor : AppColors.iconButtonBack;

    const success = AppColors.brandColor;

    const error = AppColors.red;

    const transparent = AppColors.transparent;

    final socialButtonColor =
        isLight ? AppColors.iconColor : AppColors.iconButtonBack;

    final bottomBarColor = isLight
        ? AppColors.iconColor.withOpacity(0.8)
        : AppColors.iconButtonBack;

    return CustomColorSet._(
      categoryColor: categoryColor,
      textHint: textHint,
      textBlack: textBlack,
      textWhite: textWhite,
      primary: primary,
      white: white,
      icon: icon,
      backgroundColor: backgroundColor,
      success: success,
      error: error,
      transparent: transparent,
      socialButtonColor: socialButtonColor,
      bottomBarColor: bottomBarColor,
      categoryTitleColor: categoryTitleColor,
      newBoxColor: newBoxColor,
    );
  }

  static CustomColorSet createOrUpdate(CustomThemeMode mode) {
    return CustomColorSet._create(mode);
  }
}
