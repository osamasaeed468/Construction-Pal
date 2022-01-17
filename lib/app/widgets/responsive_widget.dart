import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.mobileBody,

  }) : super(key: key);

  final Widget mobileBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) {
        if (dimens.maxWidth < kTabletBreakpoint) {
          return mobileBody;
        } else if (dimens.maxWidth >= kTabletBreakpoint &&
            dimens.maxWidth < kDesktopBreakPoint) {
          return  mobileBody;
        } else {
          return  mobileBody;
        }
      },
    );
  }
}
