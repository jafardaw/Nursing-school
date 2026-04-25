import 'package:finalproject/core/model/base_model.dart';

class UserModel {
  final BaseResponse baseResponse;
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final List<String> permissions;
  final String? token;

  UserModel({
    this.baseResponse = const BaseResponse(status: 'success', message: ''),
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.permissions = const [],
    this.token,
  });

  // 🟢 من API Response كامل (فيه status + message + data)
  factory UserModel.fromFullJson(Map<String, dynamic> json) {
    final userData = json['data']?['user'] ?? json['data'] ?? {};

    return UserModel(
      baseResponse: BaseResponse.fromJson(json),
      id: userData['id'] ?? 0,
      firstName: userData['first_name'] ?? '',
      lastName: userData['last_name'] ?? '',
      email: userData['email'] ?? '',
      role: userData['role'] ?? '',
      permissions: userData['permissions'] != null
          ? List<String>.from(userData['permissions'])
          : [],
      token: json['data']?['token'],
    );
  }

  // 🟢 من بيانات المستخدم فقط (بدون API Response)
  //   factory UserModel.fromJson(Map<String, dynamic> json) {
  //     return UserModel(
  //       baseResponse: BaseResponse(status: 'success', message: ''),
  //       id: json['id'] ?? 0,
  //       firstName: json['first_name'] ?? '',
  //       lastName: json['last_name'] ?? '',
  //       email: json['email'] ?? '',
  //       role: json['role'] ?? '',
  //       permissions: json['permissions'] != null
  //           ? List<String>.from(json['permissions'])
  //           : [],
  //     );
  //   }
  // }
}
