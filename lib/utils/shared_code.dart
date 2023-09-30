import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final double? letterSpacing;
  final double? height;
  final TextAlign? textAlign;
  const CustomText({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.overflow,
    this.textDecoration,
    this.maxLines,
    this.height,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.roboto(
          fontSize: fontSize ?? 15,
          letterSpacing: letterSpacing,
          decoration: textDecoration,
          fontWeight: fontWeight,
          color: color ?? Colors.black,
          height: height),
    );
  }
}

class EmptyPageText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final bool? isBold;
  const EmptyPageText(
      {required this.text, this.fontSize, this.isBold = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
            fontSize: fontSize ?? 24,
            fontWeight:
                isBold != null && isBold! ? FontWeight.w500 : FontWeight.normal,
            color: Colors.black),
      ),
    );
  }
}
