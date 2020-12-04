import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screen_size_widget.dart';

Card buildCard(BuildContext context, String item, {VoidCallback onTap}) {
  return Card(
    child: InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: AutoSizeText(item,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
            style: bBigSize(context)
                ? GoogleFonts.zcoolQingKeHuangYou(fontSize: 30.0, color: Colors.white)
                : GoogleFonts.zcoolQingKeHuangYou(
                    color: Colors.white,
                  )),
      ),
    ),
    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
  );
}
