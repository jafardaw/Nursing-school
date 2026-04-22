extension StringExtensions on String {
  bool get isEmail {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(this);
  }
  
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(this);
  }
  
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
  
  bool get isAlphanumeric {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(this);
  }
  
  bool get isEmptyOrNull => isEmpty;
  
  bool get isNotEmptyOrNull => isNotEmpty;
  
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s_-]+'));
    return words.map((word) => word.capitalize).join();
  }
  
  String get snakeCase {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'^_'), '').replaceAll(RegExp(r'__+'), '_');
  }
  
  String get kebabCase {
    return snakeCase.replaceAll('_', '-');
  }
  
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
  
  String get removeExtraWhitespace {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  String get reverse {
    return split('').reversed.join('');
  }
  
  String truncate(int length, {String suffix = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$suffix';
  }
  
  String mask({int visibleChars = 4, String maskChar = '*'}) {
    if (length <= visibleChars) return this;
    final maskedPart = maskChar * (length - visibleChars);
    return '$maskedPart${substring(length - visibleChars)}';
  }
  
  String removeHtmlTags() {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return replaceAll(exp, '');
  }
  
  String get initials {
    if (isEmpty) return '';
    final words = split(' ').where((word) => word.isNotEmpty);
    if (words.length == 1) return words.first[0].toUpperCase();
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }
}
