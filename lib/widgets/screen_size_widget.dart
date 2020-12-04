import 'package:flutter/material.dart';

bool bBigSize(BuildContext context) => MediaQuery.of(context).size.width > 800;

TextStyle calStyle(BuildContext context) => bBigSize(context) ? TextStyle(fontSize: 30.0) : null;

EdgeInsets calPadding(BuildContext context) => bBigSize(context) ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 64.0) : null;
