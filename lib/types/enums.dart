import 'package:flutter/material.dart';

/// Where the alert banner should be located on the screen.
///
/// [AlertBannerLocation.top] locks it to the top of the screen.
///
/// [AlertBannerLocation.bottom] locks it to the bottom of the screen.
enum AlertBannerLocation {
  top,
  bottom,
  endButtom,
  endTop,
  startButtom,
  startTop;

  AlignmentDirectional get align {
    final a = {
      AlertBannerLocation.top: AlignmentDirectional.topCenter,
      AlertBannerLocation.bottom: AlignmentDirectional.bottomCenter,
      AlertBannerLocation.endButtom: AlignmentDirectional.bottomEnd,
      AlertBannerLocation.endTop: AlignmentDirectional.topEnd,
      AlertBannerLocation.startButtom: AlignmentDirectional.bottomStart,
      AlertBannerLocation.startTop: AlignmentDirectional.topStart,
    };

    return a[this]!;
  }

  bool get isTop {
    final a = {
      AlertBannerLocation.top: true,
      AlertBannerLocation.bottom: false,
      AlertBannerLocation.endButtom: false,
      AlertBannerLocation.endTop: true,
      AlertBannerLocation.startButtom: false,
      AlertBannerLocation.startTop: true,
    };

    return a[this]!;
  }
}
