import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

class HealthStatus {
  const HealthStatus({required this.status, required this.service});
  final String status;
  final String service;
  factory HealthStatus.fromJson(Map<String, dynamic> json) => HealthStatus(
    status: json['status'] as String,
    service: json['service'] as String,
  );
}

class HealthClient {
  HealthClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 3),
              receiveTimeout: const Duration(seconds: 3),
            ),
          );
  final Dio _dio;
  Future<HealthStatus> readiness() async {
    final response = await _dio.get<Map<String, dynamic>>('/health/ready');
    return HealthStatus.fromJson(response.data!);
  }
}

final healthClientProvider = Provider<HealthClient>((ref) => HealthClient());
final healthProvider = FutureProvider<HealthStatus>(
  (ref) => ref.watch(healthClientProvider).readiness(),
  retry: (retryCount, error) => null,
);
