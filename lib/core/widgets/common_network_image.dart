import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_template_riverpod/core/theme/extension_theme.dart';

class CommonNetworkImage extends ConsumerWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final bool errorWidget;
  final BorderRadius? borderRadius;
  final bool medialPlaceHolder;
  final bool videoPlaceHolder;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget = false,
    this.borderRadius,
    this.medialPlaceHolder = false,
    this.videoPlaceHolder = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          color: ref.primaryColor,
          child:
              placeholder ??
              SizedBox(
                // width: width,
                // height: height,
                // child: Image.asset(
                //   videoPlaceHolder
                //       ? Assets.png.videoPlaceHolder.path
                //       : medialPlaceHolder
                //           ? Assets.png.mediaPlaceHolder.path
                //           : Assets.png.placeHolder.path,
                //   fit: BoxFit.fill,
                // ),
              ),
        ),
        errorWidget: (context, url, error) => errorWidget
            ? SizedBox(
                // width: width,
                // height: height,
                // child: Image.asset(
                //   videoPlaceHolder
                //       ? Assets.png.videoPlaceHolder.path
                //       : medialPlaceHolder
                //           ? Assets.png.mediaPlaceHolder.path
                //           : Assets.png.placeHolder.path,
                //   fit: BoxFit.fill,
                // ),
              )
            : const Center(child: Icon(Icons.error, color: Colors.red)),
      ),
    );
  }
}
