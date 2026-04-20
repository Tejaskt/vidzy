import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

//--- Width -----

SpaceW2 spaceW2 = SpaceW2();

class SpaceW2 extends StatelessWidget {
  static const SpaceW2 _spaceW2 = SpaceW2._i();

  factory SpaceW2() {
    return _spaceW2;
  }

  const SpaceW2._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 5.0.sp : 5.sp,
    );
  }
}

SpaceErrorPadding3 spaceErrorPaddingW3 = SpaceErrorPadding3();

class SpaceErrorPadding3 extends StatelessWidget {
  static const SpaceErrorPadding3 _spaceErrorPaddingW3 =
      SpaceErrorPadding3._i();

  factory SpaceErrorPadding3() {
    return _spaceErrorPaddingW3;
  }

  const SpaceErrorPadding3._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 10.0.sp : 14.sp,
    );
  }
}

SpaceW3 spaceW3 = SpaceW3();

class SpaceW3 extends StatelessWidget {
  static const SpaceW3 _spaceW3 = SpaceW3._i();

  factory SpaceW3() {
    return _spaceW3;
  }

  const SpaceW3._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 10.0.sp : 10.sp,
    );
  }
}

SpaceW5 spaceW5 = SpaceW5();

class SpaceW5 extends StatelessWidget {
  static const SpaceW5 _spaceW5 = SpaceW5._i();

  factory SpaceW5() {
    return _spaceW5;
  }

  const SpaceW5._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 10.0.sp : 10.sp,
    );
  }
}

SpaceW8 spaceW8 = SpaceW8();

class SpaceW8 extends StatelessWidget {
  static const SpaceW8 _spaceW8 = SpaceW8._i();

  factory SpaceW8() {
    return _spaceW8;
  }

  const SpaceW8._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 12.0.sp : 12.sp,
    );
  }
}

SpaceW10 spaceW10 = SpaceW10();

class SpaceW10 extends StatelessWidget {
  static const SpaceW10 _spaceW10 = SpaceW10._i();

  factory SpaceW10() {
    return _spaceW10;
  }

  const SpaceW10._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 15.sp : 12.sp,
    );
  }
}

SpaceW15 spaceW15 = SpaceW15();

class SpaceW15 extends StatelessWidget {
  static const SpaceW15 _spaceW15 = SpaceW15._i();

  factory SpaceW15() {
    return _spaceW15;
  }

  const SpaceW15._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 20.sp : 15.sp,
    );
  }
}

SpaceW20 spaceW20 = SpaceW20();

class SpaceW20 extends StatelessWidget {
  static const SpaceW20 _spaceW20 = SpaceW20._i();

  factory SpaceW20() {
    return _spaceW20;
  }

  const SpaceW20._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 18.sp : 16.sp,
    );
  }
}

SpaceW25 spaceW25 = SpaceW25();

class SpaceW25 extends StatelessWidget {
  static const SpaceW25 _spaceW25 = SpaceW25._i();

  factory SpaceW25() {
    return _spaceW25;
  }

  const SpaceW25._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 23.sp : 20.sp,
    );
  }
}

SpaceW35 spaceW35 = SpaceW35();

class SpaceW35 extends StatelessWidget {
  static const SpaceW35 _spaceW35 = SpaceW35._i();

  factory SpaceW35() {
    return _spaceW35;
  }

  const SpaceW35._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Device.screenType == ScreenType.tablet ? 25.sp : 35.sp,
    );
  }
}

//--- Height -----

SpaceHCustom spaceHCustom = SpaceHCustom(0);

class SpaceHCustom extends StatelessWidget {
  final double h;
  static const SpaceHCustom _spaceHCustom = SpaceHCustom._i(0);

  factory SpaceHCustom(double h) {
    return _spaceHCustom;
  }

  const SpaceHCustom._i(this.h);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h);
  }
}


SpaceH0 spaceH0 = SpaceH0();

class SpaceH0 extends StatelessWidget {
  static const SpaceH0 _spaceH0 = SpaceH0._i();

  factory SpaceH0() {
    return _spaceH0;
  }

  const SpaceH0._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 0.sp);
  }
}

SpaceH5 spaceH5 = SpaceH5();

class SpaceH5 extends StatelessWidget {
  static const SpaceH5 _spaceH5 = SpaceH5._i();

  factory SpaceH5() {
    return _spaceH5;
  }

  const SpaceH5._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 5.sp : 5.sp,
    );
  }
}

SpaceH8 spaceH8 = SpaceH8();

class SpaceH8 extends StatelessWidget {
  static const SpaceH8 _spaceH8 = SpaceH8._i();

  factory SpaceH8() {
    return _spaceH8;
  }

  const SpaceH8._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 8.sp : 8.sp,
    );
  }
}

SpaceH10 spaceH10 = SpaceH10();

class SpaceH10 extends StatelessWidget {
  static const SpaceH10 _spaceH10 = SpaceH10._i();

  factory SpaceH10() {
    return _spaceH10;
  }

  const SpaceH10._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 10.sp : 12.sp,
    );
  }
}

SpaceH15 spaceH15 = SpaceH15();

class SpaceH15 extends StatelessWidget {
  static const SpaceH15 _spaceH15 = SpaceH15._i();

  factory SpaceH15() {
    return _spaceH15;
  }

  const SpaceH15._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 15.sp : 15.sp,
    );
  }
}

SpaceH20 spaceH20 = SpaceH20();

class SpaceH20 extends StatelessWidget {
  static const SpaceH20 _spaceH20 = SpaceH20._i();

  factory SpaceH20() {
    return _spaceH20;
  }

  const SpaceH20._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 18.sp : 16.sp,
    );
  }
}

SpaceH30 spaceH30 = SpaceH30();

class SpaceH30 extends StatelessWidget {
  static const SpaceH30 _spaceH30 = SpaceH30._i();

  factory SpaceH30() {
    return _spaceH30;
  }

  const SpaceH30._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 20.sp : 20.sp,
    );
  }
}

SpaceH40 spaceH40 = SpaceH40();

class SpaceH40 extends StatelessWidget {
  static const SpaceH40 _spaceH40 = SpaceH40._i();

  factory SpaceH40() {
    return _spaceH40;
  }

  const SpaceH40._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 18.sp : 25.sp,
    );
  }
}

SpaceH50 spaceH50 = SpaceH50();

class SpaceH50 extends StatelessWidget {
  static const SpaceH50 _spaceH50 = SpaceH50._i();

  factory SpaceH50() {
    return _spaceH50;
  }

  const SpaceH50._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 30.0.sp : 35.0.sp,
    );
  }
}

SpaceH100 spaceH100 = SpaceH100();

class SpaceH100 extends StatelessWidget {
  static const SpaceH100 _spaceH100 = SpaceH100._i();

  factory SpaceH100() {
    return _spaceH100;
  }

  const SpaceH100._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 18.sp : 45.sp,
    );
  }
}

SpaceH80 spaceH80 = SpaceH80();

class SpaceH80 extends StatelessWidget {
  static const SpaceH80 _spaceH80 = SpaceH80._i();

  factory SpaceH80() {
    return _spaceH80;
  }

  const SpaceH80._i();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.screenType == ScreenType.tablet ? 20.sp : 50.sp,
    );
  }
}
