import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final IconData materialIcon;
  final String? svgPath;
  final double size;
  final Color? color;
  final bool useCustom;

  const AppIcon({
    super.key,
    required this.materialIcon,
    this.svgPath,
    this.size = 24,
    this.color,
    this.useCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    return useCustom && svgPath != null
        ? SvgPicture.asset(
            svgPath!,
            height: size,
            width: size,
            color: color ?? IconTheme.of(context).color,
          )
        : Icon(
            materialIcon,
            size: size,
            color: color,
          );
  }
}
