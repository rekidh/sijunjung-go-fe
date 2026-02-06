class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int code;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.code,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
