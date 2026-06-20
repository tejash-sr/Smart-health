import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../di/injection_container.dart';
import '../error/exceptions.dart';

/// Thin, production-grade HTTP client for the Pulse Engage backend.
///
/// Responsibilities:
///   - Build absolute URIs from the configured [baseUrl]
///   - Attach JSON content-type and bearer-token headers
///   - Enforce a request timeout
///   - Decode JSON responses and surface backend error messages
///   - Translate transport / decode failures into typed
///     [ServerException] / [UnauthorizedException] / [CacheException]
///
/// Returns decoded JSON as either `Map<String, dynamic>`, `List<dynamic>`,
/// or `null` for empty bodies. Callers are expected to cast to the
/// expected shape and handle [Exception]s.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    Duration? timeout,
  })  : _client = client ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 20);

  final http.Client _client;
  final String baseUrl;
  final Duration _timeout;

  Map<String, String> get _headers {
    final token = sl.localStorage.getToken();
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String endpoint) {
    final normalised =
        endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$normalised');
  }

  Future<Object?> get(String endpoint) => _send(
        () => _client.get(_uri(endpoint), headers: _headers).timeout(_timeout),
      );

  Future<Object?> post(String endpoint, {Map<String, dynamic>? body}) => _send(
        () => _client
            .post(
              _uri(endpoint),
              headers: _headers,
              body: body == null ? null : json.encode(body),
            )
            .timeout(_timeout),
      );

  Future<Object?> put(String endpoint, {Map<String, dynamic>? body}) => _send(
        () => _client
            .put(
              _uri(endpoint),
              headers: _headers,
              body: body == null ? null : json.encode(body),
            )
            .timeout(_timeout),
      );

  Future<Object?> delete(String endpoint) => _send(
        () =>
            _client.delete(_uri(endpoint), headers: _headers).timeout(_timeout),
      );

  Future<Object?> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      return _processResponse(response);
    } on ServerException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } on TimeoutException catch (e) {
      throw ServerException(message: 'Request timed out: ${e.message ?? ''}');
    } on FormatException catch (e) {
      throw ServerException(message: 'Malformed response: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Network error: $e');
    }
  }

  Object? _processResponse(http.Response response) {
    final status = response.statusCode;
    final body = response.body;

    final Object? decoded = body.isEmpty ? null : json.decode(body);

    if (status >= 200 && status < 300) {
      return decoded;
    }

    final backendMessage = _extractMessage(decoded) ??
        'Request failed with status code $status';

    if (status == 401 || status == 403) {
      throw UnauthorizedException(message: backendMessage);
    }
    throw ServerException(message: backendMessage, statusCode: status);
  }

  String? _extractMessage(Object? decoded) {
    if (decoded is Map<String, dynamic>) {
      final m = decoded['message'] ?? decoded['error'] ?? decoded['detail'];
      if (m is String && m.isNotEmpty) return m;
    }
    return null;
  }

  void close() => _client.close();
}
