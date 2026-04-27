 import 'package:flutter/material.dart';

CircleAvatar circleName({
    required String firstNameFirstchar,
    required double radius,
    required Color backgroundColor,
    required TextStyle textStyle,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        firstNameFirstchar,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }