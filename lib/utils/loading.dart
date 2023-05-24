import 'package:flutter/material.dart';

showLoading(Color color, double strokeWidth) {
  return Center(
    child: CircularProgressIndicator(
      color: color,
      strokeWidth: strokeWidth,
    ),
  );
}
