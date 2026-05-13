class AppConstants {
  // App Info
  static const String appName = 'تطبيق التمريض';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrlPublic =
      'https://nursing-school.onrender.com/api/';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int phoneLength = 10;

  // Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  static const String roleKey = 'role';

  //lists

  static const List<ItemModel> housingTypes = [
    ItemModel(id: 1, name: 'Internal'),
    ItemModel(id: 2, name: 'External')
  ];
  static const List<ItemModel> studyTypes = [
    ItemModel(id: 1, name: 'Regular'),
    ItemModel(id: 2, name: 'Transfer')
  ];
  static const List<ItemModel> academicYears = [
      ItemModel(id: 1, name: 'الأولى'),
   ItemModel(id: 3, name: 'الثالثة'),
   ItemModel(id: 2, name: 'الثانية'),
   ItemModel(id: 5, name: 'الخامسة'),
   ItemModel(id: 4, name: 'الرابعة'),

  ];

  static const List<ItemModel> nationalities = [
    ItemModel(id: 7, name: 'أجنبية'),
    ItemModel(id: 1, name: 'سورية'),
    ItemModel(id: 3, name: 'عراقية'),

    ItemModel(id: 6, name: 'عربية'),
    ItemModel(id: 5, name: 'فلسطينية مقيم في الخارج'),
    ItemModel(id: 4, name: 'فلسطينية مقيم في سوريا'),
    ItemModel(id: 2, name: 'لبنانية'),
  ];
  static const List<ItemModel> governorates = [
    ItemModel(id: 1, name: 'دمشق'),
    ItemModel(id: 2, name: 'ريف دمشق'),
    ItemModel(id: 3, name: 'حلب'),
    ItemModel(id: 4, name: 'حمص'),
    ItemModel(id: 5, name: 'حماة'),
    ItemModel(id: 6, name: 'اللاذقية'),
    ItemModel(id: 7, name: 'طرطوس'),
    ItemModel(id: 8, name: 'دير الزور'),
    ItemModel(id: 9, name: 'الحسكة'),
    ItemModel(id: 10, name: 'إدلب'),
    ItemModel(id: 11, name: 'الرقة'),
    ItemModel(id: 12, name: 'درعا'),
    ItemModel(id: 13, name: 'السويداء'),
    ItemModel(id: 14, name: 'القنيطرة'),
  ];

  AppConstants._();
}

class ItemModel {
  final int id;
  final String name;

  const ItemModel({required this.id, required this.name});
}
