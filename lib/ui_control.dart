import 'dart:math';

import 'package:flutter/material.dart';

class UIControl {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Size _emuSize = const Size(360, 640);

  static BuildContext? get _context => UIControl.navigatorKey.currentContext;

  static Size get _screenSize => MediaQuery.of(_context!).size;

  // ignore: avoid_setters_without_getters
  static set changeEmulatorSize(Size size) => _emuSize = size;

  // ignore: avoid_setters_without_getters
  static set changeNavigatorKey(GlobalKey<NavigatorState> newKey) =>
      navigatorKey = newKey;

  static double _wsz(double size) {
    assert(
      _context != null,
      'set navigatorKey: UIControl.navigatorKey on MaterialApp',
    );
    return (size / _emuSize.width) * _screenSize.width;
  }

  static double _hsz(double size) {
    assert(
      _context != null,
      'set navigatorKey: UIControl.navigatorKey on MaterialApp',
    );
    return (size / _emuSize.height) * _screenSize.height;
  }

  static double _sz(double size) {
    if (size < 0) {
      final double aux = size * -1;
      return -min(_wsz(aux), _hsz(aux));
    }
    return min(_wsz(size), _hsz(size));
  }

  static bool _useWsz = false;
  static bool _useHsz = false;
  static bool _useSz = true;

  static void useWsz() => _clear(wsz: true);

  static void useHsz() => _clear(hsz: true);

  static void useSz() => _clear(sz: true);

  static void _clear({bool? sz, bool? hsz, bool? wsz}) {
    _useSz = sz ?? false;
    _useHsz = hsz ?? false;
    _useWsz = wsz ?? false;
  }

  static double _apply(double value) {
    if (value.isInfinite) return value;
    if (_useWsz) return wsz(value);
    if (_useHsz) return hsz(value);
    if (_useSz) return sz(value);
    return value;
  }
}

double apply(double size) {
  return UIControl._apply(size);
}

double sz(double size) {
  return UIControl._sz(size);
}

double wsz(double size) {
  return UIControl._wsz(size);
}

double hsz(double size) {
  return UIControl._hsz(size);
}

extension UIControlExtension on num {
  double get a => UIControl._apply(toDouble());

  double get wsz => UIControl._wsz(toDouble());

  double get sz => UIControl._sz(toDouble());

  double get hsz => UIControl._hsz(toDouble());
}
