import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PulseLoader extends StatefulWidget {
  const PulseLoader({this.size, super.key});

  final double? size;

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Smooth 1-second full rotation
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 16.w; // Larger default size
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Curve 1 (Top) - Full brightness (head of the loader)
              Opacity(
                opacity: 1.0,
                child: Assets.icons.loaderTop.svg(
                  width: size,
                  height: size,
                  colorFilter: const ColorFilter.mode(
                    AppColors.accent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Curve 2 (Right) - Fading segment
              Opacity(
                opacity: 0.75,
                child: Assets.icons.loaderRight.svg(
                  width: size,
                  height: size,
                  colorFilter: const ColorFilter.mode(
                    AppColors.accent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Curve 3 (Bottom) - Fader segment
              Opacity(
                opacity: 0.45,
                child: Assets.icons.loaderBottom.svg(
                  width: size,
                  height: size,
                  colorFilter: const ColorFilter.mode(
                    AppColors.accent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Curve 4 (Left) - Tail of the loader (faded out)
              Opacity(
                opacity: 0.15,
                child: Assets.icons.loaderLeft.svg(
                  width: size,
                  height: size,
                  colorFilter: const ColorFilter.mode(
                    AppColors.accent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
