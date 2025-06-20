import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/exception.dart';
import 'session_manager.dart';

/// A small wrapper around [http.Client] that applies a timeout and
/// converts common networking errors into [CustomExeption]s.
class HttpClientService {
  final http.Client _client;
  final Duration timeout;

  HttpClientService(
      {http.Client? client, this.timeout = const Duration(minutes: 15)})
      : _client = client ?? http.Client();

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _safeRequest(() => _client.get(url, headers: headers));
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body}) {
    return _safeRequest(() => _client.post(url, headers: headers, body: body));
  }

  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body}) {
    return _safeRequest(() => _client.patch(url, headers: headers, body: body));
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers}) {
    return _safeRequest(() => _client.delete(url, headers: headers));
  }

  Future<http.Response> _safeRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(timeout);
      if (response.statusCode == 401) {
        try {
          final data = jsonDecode(response.body);
          if (data is Map && data['message'] == 'Unauthorized: Invalid token') {
            SessionManager.handleUnauthorized();
            throw CustomExeption('Unauthorized: Invalid token');
          }
        } catch (_) {}
      }
      return response;
    } on TimeoutException {
      throw CustomExeption('Request timed out');
    } on SocketException {
      throw CustomExeption('Network error');
    } catch (e) {
      throw CustomExeption(e.toString());
    }
  }

  void close() => _client.close();
}
