class TafqeetHelper {
  static const Map<int, String> _units = {
    1: 'واحد',
    2: 'اثنان',
    3: 'ثلاثة',
    4: 'أربعة',
    5: 'خمسة',
    6: 'ستة',
    7: 'سبعة',
    8: 'ثمانية',
    9: 'تسعة',
  };

  static const Map<int, String> _teens = {
    10: 'عشرة',
    11: 'أحد عشر',
    12: 'اثنا عشر',
    13: 'ثلاثة عشر',
    14: 'أربعة عشر',
    15: 'خمسة عشر',
    16: 'ستة عشر',
    17: 'سبعة عشر',
    18: 'ثمانية عشر',
    19: 'تسعة عشر',
  };

  static const Map<int, String> _tens = {
    20: 'عشرون',
    30: 'ثلاثون',
    40: 'أربعون',
    50: 'خمسون',
    60: 'ستون',
    70: 'سبعون',
    80: 'ثمانون',
    90: 'تسعون',
  };

  /// يحول العلامة الرقمية (من 0 إلى 100) إلى تفقيط عربي نصي
  static String convert(double number) {
    if (number < 0 || number > 100) return 'خارج النطاق';
    if (number == 0) return 'صفر';
    if (number == 100) return 'مئة';

    final int integerPart = number.toInt();
    final double fractionPart = number - integerPart;

    String words = '';

    // معالجة الجزء الصحيح
    if (integerPart > 0) {
      if (integerPart < 10) {
        words = _units[integerPart]!;
      } else if (integerPart >= 10 && integerPart < 20) {
        words = _teens[integerPart]!;
      } else {
        final int unit = integerPart % 10;
        final int ten = (integerPart ~/ 10) * 10;

        if (unit == 0) {
          words = _tens[ten]!;
        } else {
          words = '${_units[unit]} و${_tens[ten]}';
        }
      }
    }

    // معالجة الكسر العشري (تقريب لأقرب ربع ونصف)
    if (fractionPart > 0) {
      // تقريب الكسر لأقرب قيم شائعة: 0.25، 0.5، 0.75
      final double roundedFraction = (fractionPart * 4).round() / 4;
      
      String fractionText = '';
      if (roundedFraction == 0.25) {
        fractionText = 'وربع';
      } else if (roundedFraction == 0.5) {
        fractionText = 'ونصف';
      } else if (roundedFraction == 0.75) {
        fractionText = 'وثلاثة أرباع';
      }

      if (fractionText.isNotEmpty) {
        if (words.isEmpty) {
          words = fractionText.replaceFirst('و', ''); // إذا كان هناك كسر فقط بدون صحيح
        } else {
          words = '$words $fractionText';
        }
      }
    }

    return words;
  }
}
