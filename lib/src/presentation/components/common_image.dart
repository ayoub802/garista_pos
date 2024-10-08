import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/utils/app_helpers.dart';
import '../../core/constants/secret_vars.dart';
import '../theme/theme.dart';
import 'shimmers/make_shimmer.dart';

class CommonImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double radius;
  final bool isResponsive;
  final File? fileImage;

  const CommonImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 10,
    this.isResponsive = true,
    this.fileImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: fileImage != null
          ? Image.file(
              fileImage!,
              height: height,
              width: width,
              fit: BoxFit.cover,
            )
          : AppHelpers.checkIsSvg(imageUrl)
              ? SvgPicture.network(
                  '${SecretVars.S3Url}/$imageUrl',
                  width: isResponsive ? width.r : width,
                  height: isResponsive ? height.r : height,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius.r),
                      color: AppColors.white,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: '${SecretVars.S3Url}/$imageUrl',
                  width: isResponsive ? width.r : width,
                  height: isResponsive ? height.r : height,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) {
                    return MakeShimmer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              isResponsive ? radius.r : radius),
                          color: AppColors.mainBack,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      width: isResponsive ? width.r : width,
                      height: isResponsive ? height.r : height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            isResponsive ? radius.r : radius),
                        border: Border.all(color: AppColors.borderColor),
                        color: AppColors.mainBack,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        FlutterRemix.image_line,
                        color: AppColors.black.withOpacity(0.5),
                        size: isResponsive ? 20.r : 20,
                      ),
                    );
                  },
                ),
    );
  }
}
