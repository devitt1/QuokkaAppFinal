import 'package:flutter/material.dart';

class TextStyles {
  static double fontSize14 = 14;
  static double fontSize16 = 16;

  static double _lineHeightRatioFromPx(int lineHeightPx, int fontSizePx) {
    return lineHeightPx / fontSizePx;
  }

  static TextStyle roobertStyle({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return TextStyle(
      fontFamily: 'Roobert',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle roobertDisplayMd48 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 48,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertDisplayMd56 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 56,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertDisplayMd48SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 48,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertDisplayMd56SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 56,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertDisplayMd48Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertDisplayMd56Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 56,
    fontWeight: FontWeight.w700,
  );

  // DC: Display sm text styles
  static TextStyle roobertDisplaySm40 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 40,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertDisplaySm48 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 48,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertDisplaySm40SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 40,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertDisplaySm48SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 48,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertDisplaySm40Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertDisplaySm48Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );

  // Display xs text styles
  static TextStyle roobertDisplayXs32 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertDisplayXs40 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 40,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertDisplayXs32SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertDisplayXs40SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 40,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertDisplayXs32Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertDisplayXs40Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  // DC: Text xl text styles

  static TextStyle roobertTextXl24 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextXl32 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextXl24SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextXl32SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextXl24Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertTextXl32Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  // DC: text lg text styles

  static TextStyle roobertTextLg20 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextLg30 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextLg20SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextLg30SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextLg20Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertTextLg30Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  // DC: text md text styles
  static TextStyle roobertTextMd16 = TextStyle(
    fontFamily: 'Roobert',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: _lineHeightRatioFromPx(20, 16),
  );

  static TextStyle roobertTextMd24 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextMd16SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextMd24SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextMd16Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertTextMd24Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  // DC: text sm text styles
  static TextStyle roobertTextSm14 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextSm24 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextSm14SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextSm24SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextSm14Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertTextSm24Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  // DC: text xs text styles
  static TextStyle roobertTextXs12 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextXs24 = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static TextStyle roobertTextXs12SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextXs24SemiBold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle roobertTextXs12Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle roobertTextXs24Bold = const TextStyle(
    fontFamily: 'Roobert',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  // DC: Satoshi text styles

  static TextStyle satoshiTextMd40Bold = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: _lineHeightRatioFromPx(48, 40),
  );

  static TextStyle satoshiTextMd32Bold = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: _lineHeightRatioFromPx(38, 32),
  );

  static TextStyle satoshiTextSm16 = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: _lineHeightRatioFromPx(16, 16),
  );
}
