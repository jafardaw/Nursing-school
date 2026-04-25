class BaseResponse {
  final String status;
  final String message;

 const BaseResponse({
    required this.status,
    required this.message,
  });

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
    );
  }
}