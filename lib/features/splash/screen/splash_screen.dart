import 'dart:async';
import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/widgets/pulse_loader.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:ad_campaign_dashboard/routes/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _loaderController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _textSlide;
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlide = Tween<double>(begin: 4.h, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loaderController, curve: Curves.easeIn),
    );

    // Sequence the animations smoothly
    _logoController.forward();

    Timer(const Duration(milliseconds: 350), () {
      if (mounted) _textController.forward();
    });

    Timer(const Duration(milliseconds: 900), () {
      if (mounted) _loaderController.forward();
    });

    // Automatically navigate to dashboard after loading completes
    Timer(const Duration(milliseconds: 2700), () {
      if (mounted) {
        context.go(RoutePaths.campaigns);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111113), // Deep premium dark background
      body: SafeArea(
        child: Stack(
          children: [
            // Background subtle gradients for premium visual wow factor
            Positioned(
              top: -10.h,
              right: -10.w,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -15.h,
              left: -10.w,
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing Neon Logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF133F4A),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.25),
                                  blurRadius: 35,
                                  spreadRadius: 6,
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Assets.icons.campaignNavIcon.svg(
                                width: 11.w,
                                height: 11.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.accent,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 3.5.h),
                  // Animated Text Brand Title
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _textSlide.value),
                          child: Column(
                            children: [
                              Text(
                                'OCTANE',
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 8,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 0.8.h),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [AppColors.accent, Color(0xFF00E5FF)],
                                ).createShader(bounds),
                                child: Text(
                                  'AD DASHBOARD',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Loading Spinner at bottom
            Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _loaderController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _loaderOpacity.value,
                    child: PulseLoader(size: 13.w), // Removed const prefix here
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
