// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartworx/constant.dart';
import 'package:toastification/toastification.dart';

var dio = Dio(
  BaseOptions(
    baseUrl: 'https://esumbongmo-backend-beta.faciliteq.net',
    followRedirects: false,
    validateStatus: (status) => status! <= 500,
  ),
);

class ApiError {
  final String message;
  final String key;
  final String context;

  const ApiError({
    required this.message,
    required this.key,
    required this.context,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        message: json['message'],
        key: json['key'],
        context: json['context'],
      );
}

class ApiResponse {
  final bool success;
  final String? context;
  final String? message;
  final List<ApiError>? errors;
  final dynamic data;

  const ApiResponse({
    required this.success,
    this.context,
    this.errors,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json['success'],
        context: json['context'],
        errors: (json['errors'] ?? [])
            .map<ApiError>((error) => ApiError.fromJson(error))
            .toList(),
        message: json['message'],
        data: json['data'],
      );
}

Future<ApiResponse> userLogin(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    var path = "/v1/auth/login";
    Map<String, dynamic> payload = {
      'type': 'Contractor',
      'password': password,
      'email': email,
    };
    Response response = await dio.post(
      path,
      data: payload,
    );
    if (response.data != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: response.data);
      }
      return ApiResponse(success: false, message: response.data["message"]);
    } else {
      return const ApiResponse(success: false);
    }
  } on DioException catch (e) {
    toast(
      context,
      ToastificationType.warning,
      'You are offline',
    );
    return ApiResponse(success: false, message: e.message);
  } catch (e) {
    return ApiResponse(success: false, message: '$e');
  }
}

Future<ApiResponse> getReports(
  BuildContext context,
) async {
  try {
    var path = "/v1/reports/?assignedResolver=${userData['contractorId']}";
    Response response = await dio.get(
      path,
    );
    if (response.data != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: response.data);
      }
      return ApiResponse(success: false, message: response.data["message"]);
    } else {
      return const ApiResponse(success: false);
    }
  } on DioException catch (e) {
    toast(
      context,
      ToastificationType.warning,
      'You are offline',
    );
    return ApiResponse(success: false, message: e.message);
  } catch (e) {
    return ApiResponse(success: false, message: '$e');
  }
}

Future<ApiResponse> updateReports(
  BuildContext context,
  String id,
  String status,
) async {
  try {
    var path = "/v1/reports/$id";
    Map<String, dynamic> payload = {
      'status': status,
    };
    Response response = await dio.put(
      path,
      data: payload,
    );
    if (response.data != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: response.data);
      }
      return ApiResponse(success: false, message: response.data["message"]);
    } else {
      return const ApiResponse(success: false);
    }
  } on DioException catch (e) {
    toast(
      context,
      ToastificationType.warning,
      'You are offline',
    );
    return ApiResponse(success: false, message: e.message);
  } catch (e) {
    return ApiResponse(success: false, message: '$e');
  }
}

Future<ApiResponse> getProvinceById(
  BuildContext context,
  int id,
) async {
  try {
    var path = "/v1/locations/provinces/$id";
    Response response = await dio.get(
      path,
    );
    if (response.data != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: response.data);
      }
      return ApiResponse(success: false, message: response.data["message"]);
    } else {
      return const ApiResponse(success: false);
    }
  } on DioException catch (e) {
    toast(
      context,
      ToastificationType.warning,
      'You are offline',
    );
    return ApiResponse(success: false, message: e.message);
  } catch (e) {
    return ApiResponse(success: false, message: '$e');
  }
}

Future<ApiResponse> getCityById(
  BuildContext context,
  int id,
) async {
  try {
    var path = "/v1/locations/citymuns/$id";
    Response response = await dio.get(
      path,
    );
    if (response.data != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: response.data);
      }
      return ApiResponse(success: false, message: response.data["message"]);
    } else {
      return const ApiResponse(success: false);
    }
  } on DioException catch (e) {
    toast(
      context,
      ToastificationType.warning,
      'You are offline',
    );
    return ApiResponse(success: false, message: e.message);
  } catch (e) {
    return ApiResponse(success: false, message: '$e');
  }
}

Future<ApiResponse> getBarangayById(
  BuildContext context,
  int id,
) async {
  try {
    var path = "/v1/locations/barangays/$id";
    Response response = await dio.get(
      path,
    );
    if (response.data != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: response.data);
      }
      return ApiResponse(success: false, message: response.data["message"]);
    } else {
      return const ApiResponse(success: false);
    }
  } on DioException catch (e) {
    toast(
      context,
      ToastificationType.warning,
      'You are offline',
    );
    return ApiResponse(success: false, message: e.message);
  } catch (e) {
    return ApiResponse(success: false, message: '$e');
  }
}
