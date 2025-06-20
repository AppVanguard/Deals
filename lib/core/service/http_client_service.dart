import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exception.dart';

/// A small wrapper around [http.Client] that applies a timeout and
/// converts common networking errors into [CustomExeption]s.
class HttpClientService {
  final http.Client _client;
  final Duration timeout;

  HttpClientService({http.Client? client, this.timeout = const Duration(seconds: 15)})
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
      return await request().timeout(timeout);
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
