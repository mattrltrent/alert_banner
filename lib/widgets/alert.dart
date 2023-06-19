import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';

dynamic showAlertBanner(
  BuildContext context,
  VoidCallback onTap,
  Widget child, {
  AlertBannerLocation alertBannerLocation = AlertBannerLocation.top,
  double? maxLength,
  Duration? durationOfStayingOnScreen,
  Duration? durationOfScalingUp,
  Duration? durationOfScalingDown,
  Duration? durationOfLeavingScreenBySwipe,
  Curve? curveScaleUpAnim,
  Curve? curveScaleDownAnim,
  Curve? curveTranslateAnim,
  bool safeAreaTopEnabled = true,
  bool safeAreaBottomEnabled = true,
  bool safeAreaLeftEnabled = true,
  bool safeAreaRightEnabled = true,
}) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return Align(
        alignment: alertBannerLocation.align,
        child: SafeArea(
          top: safeAreaTopEnabled,
          bottom: safeAreaBottomEnabled,
          left: safeAreaLeftEnabled,
          right: safeAreaRightEnabled,
          child: _OverlayItem(
            onTap: onTap,
            curveScaleDownAnim: curveScaleDownAnim ?? Curves.decelerate,
            curveScaleUpAnim: curveScaleUpAnim ?? Curves.easeOutBack,
            curveTranslateAnim: curveTranslateAnim ?? Curves.ease,
            durationOfScalingUp:
                durationOfScalingUp ?? const Duration(milliseconds: 400),
            durationOfScalingDown:
                durationOfScalingDown ?? const Duration(milliseconds: 250),
            durationOfLeavingScreenBySwipe: durationOfLeavingScreenBySwipe ??
                const Duration(milliseconds: 1500),
            alertBannerLocation: alertBannerLocation,
            maxWidth: maxLength,
            overlay: overlay,
            duration:
                durationOfStayingOnScreen ?? const Duration(milliseconds: 3500),
            child: child,
          ),
        ),
      );
    },
  );
  Overlay.of(context).insert(overlay);
}

class _OverlayItem extends StatefulWidget {
  const _OverlayItem({
    Key? key,
    required this.onTap,
    required this.child,
    required this.overlay,
    required this.duration,
    required this.durationOfLeavingScreenBySwipe,
    required this.durationOfScalingDown,
    required this.durationOfScalingUp,
    required this.alertBannerLocation,
    required this.curveScaleDownAnim,
    required this.curveScaleUpAnim,
    required this.curveTranslateAnim,
    this.maxWidth,
  }) : super(key: key);

  /// When the alert_banner gets tapped.
  final VoidCallback onTap;

  /// Where the alert_banner is displayed (top or bottom of screen).
  final AlertBannerLocation alertBannerLocation;

  /// Child widget of alert_banner.
  final Widget child;

  /// Max width of alert_banner.
  final double? maxWidth;

  /// The passed overlay instance.
  final OverlayEntry? overlay;

  /// How long the alert_banner stays on the screen for.
  final Duration duration;

  /// Duration of scale up animation.
  final Duration durationOfScalingUp;

  /// Duration of scale down animation.
  final Duration durationOfScalingDown;

  /// Duration of leaving screen animation.
  final Duration durationOfLeavingScreenBySwipe;

  /// Curve of scale up animation.
  final Curve curveScaleUpAnim;

  /// Curve of scale down animation.
  final Curve curveScaleDownAnim;

  /// Curve of translation (moving on y-axis) animation.
  final Curve curveTranslateAnim;

  @override
  State<_OverlayItem> createState() => __OverlayItemState();
}

class __OverlayItemState extends State<_OverlayItem>
    with TickerProviderStateMixin {
  // Initialize the translation animations/controllers.
  late AnimationController translateAnimController;
  late Animation translateAnim;

  // Initialize the scale animations/controllers.
  late AnimationController scaleAnimController;
  late Animation scaleAnim;

  /// Set parameters of animations in initState.
  @override
  void initState() {
    translateAnimController = AnimationController(
      vsync: this,
      duration: widget.durationOfLeavingScreenBySwipe,
    );
    translateAnim = CurvedAnimation(
      parent: translateAnimController,
      curve: widget.curveTranslateAnim,
    );
    scaleAnimController = AnimationController(
      vsync: this,
      duration: widget.durationOfScalingUp,
      reverseDuration: widget.durationOfScalingDown,
    );
    scaleAnim = CurvedAnimation(
      parent: scaleAnimController,
      curve: widget.curveScaleUpAnim,
      reverseCurve: widget.curveScaleDownAnim,
    );
    startAnim();
    super.initState();
  }

  /// Dispose animations when done with.
  @override
  void dispose() {
    translateAnimController.dispose();
    scaleAnimController.dispose();
    super.dispose();
  }

  /// Reverses the animation early when called.
  ///
  /// AKA: Hides the alert_banner via animation.
  void reverseAnimEarly() {
    if (!mounted || widget.overlay == null) return;
    translateAnimController.forward().then((value) => widget.overlay!.remove());
    translateAnimController.addListener(() => setState(() {}));
  }

  /// Brings out the alert_banner.
  ///
  /// AKA: Makes it visible via animation.
  void startAnim() {
    if (!mounted || widget.overlay == null) return;
    scaleAnimController.forward().then((_) async {
      await Future.delayed(widget.duration);
      if (!mounted || widget.overlay == null) return;
      scaleAnimController.reverse().then((value) => widget.overlay!.remove());
    });
    scaleAnimController.addListener(() => setState(() {}));
  }

  // Amount the user has swiped vertically.
  double _swipeDy = 0.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
          0,
          widget.alertBannerLocation == AlertBannerLocation.top
              ? (translateAnim.value * -MediaQuery.of(context).size.height +
                  (_swipeDy <= 0 ? _swipeDy : 0))
              : (translateAnim.value * MediaQuery.of(context).size.height +
                  (_swipeDy >= 0 ? _swipeDy : 0))),
      // Triggers for controlling the animations are handled via a GestureDetector.
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (widget.alertBannerLocation == AlertBannerLocation.top
              ? _swipeDy < 0
              : _swipeDy > 0) {
            reverseAnimEarly();
          }
        },
        onVerticalDragCancel: () {
          if (widget.alertBannerLocation == AlertBannerLocation.top
              ? _swipeDy <= 0
              : _swipeDy >= 0) {
            reverseAnimEarly();
          }
        },
        onVerticalDragUpdate: (details) {
          if (translateAnim.value != 0) return;
          if (widget.alertBannerLocation == AlertBannerLocation.top
              ? (details.delta.dy <= 0 || _swipeDy < 0)
              : (details.delta.dy >= 0 || _swipeDy > 0)) {
            setState(() {
              _swipeDy += details.delta.dy;
            });
          }
        },
        // Controlled child that is the actual alert_banner.
        child: Transform.scale(
          scale: scaleAnim.value,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            constraints: BoxConstraints(
                maxWidth:
                    widget.maxWidth ?? MediaQuery.of(context).size.width * 0.8),
            child: GestureDetector(
              onTap: () => widget.onTap(),
              child: Material(
                color: Colors.transparent,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
