// Abstraction for HTTP requests

// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

// Time allowed for API to complet response
const TIMEOUT_DURATION = Duration(seconds: 5);

enum RequestType {
  GET,
  POST,
  PATCH,
  DELETE,
}

class APIRequest {
  RequestType type;
  String fullUrl;
  String? body;
  Map<String, String>? extraHeaders;
  String? authToken;

  APIRequest({
    required this.type,
    required this.fullUrl,
    this.body,
    this.extraHeaders,
    this.authToken,
  });
}

class APIResponse {
  bool success = false;
  int statusCode;
  String result = ''; // the result if success = true
  String? errorMessage = ''; // a friendly error message to display to the user

  APIResponse({
    required this.success,
    required this.statusCode,
    required this.result,
    this.errorMessage,
  });
}

// Standard HTTP codes
const HTTP_CODE_SUCCESS = 200;
const HTTP_CODE_SUCCESS_MAX = 299;
const HTTP_CODE_NOT_FOUND = 404;
const HTTP_CODE_UNAUTHENTICATED = 401;
// Custom HTTP codes to indicate errors
const HTTP_CODE_BAD_RESPONSE = -1;
const HTTP_CODE_NO_INTERNET = -2;
const HTTP_CODE_RETRY = -3;
const HTTP_CODE_UNKNOWN = -4;

const Map<int, String> errorCodeNames = {
  HTTP_CODE_NO_INTERNET: 'No internet connection.',
  HTTP_CODE_BAD_RESPONSE: 'Bad response from server.',
  HTTP_CODE_NOT_FOUND: 'Not found.',
  HTTP_CODE_UNKNOWN: 'Unknown error',
};

class HTTPClient {
  late IOClient client;
  final Duration timeoutDuration = TIMEOUT_DURATION;

  HttpClient customClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  HTTPClient() {
    client = IOClient(customClient);
  }

  Map<String, String> getHeaders(APIRequest request) {
    final isAuthenticated = request.authToken?.isNotEmpty ?? false;

    // Default headers
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (isAuthenticated) {
      headers['Authorization'] = 'Bearer ${request.authToken}';
    }
    if (request.extraHeaders?.isNotEmpty ?? false) {
      headers.addAll(request.extraHeaders!);
    }

    return headers;
  }

  FutureOr<http.Response> _onTimeoutError() async =>
      Future.error("The connection has timed out.");

  Future<APIResponse> request(APIRequest request) async {
    try {
      // using ternary operator since there is only two types of request
      // If need more convert to switch statement
      final dynamic response;
      switch (request.type) {
        case RequestType.GET:
          response = await client
              .get(
                Uri.parse(request.fullUrl),
                headers: getHeaders(request),
              )
              .timeout(
                timeoutDuration,
                onTimeout: () => _onTimeoutError(),
              );
          break;
        case RequestType.POST:
          response = await client
              .post(
                Uri.parse(request.fullUrl),
                body: request.body,
                headers: getHeaders(request),
              )
              .timeout(
                timeoutDuration,
                onTimeout: () => _onTimeoutError(),
              );
          break;
        case RequestType.PATCH:
          response = await client
              .patch(Uri.parse(request.fullUrl),
                  body: request.body, headers: getHeaders(request))
              .timeout(
                timeoutDuration,
                onTimeout: () => _onTimeoutError(),
              );
          break;
        case RequestType.DELETE:
          response = await client
              .delete(Uri.parse(request.fullUrl),
                  body: request.body, headers: getHeaders(request))
              .timeout(
                timeoutDuration,
                onTimeout: () => _onTimeoutError(),
              );
          break;
      }

      final int statusCode = response.statusCode;

      if (!(statusCode >= HTTP_CODE_SUCCESS &&
          statusCode <= HTTP_CODE_SUCCESS_MAX)) {
        return APIResponse(
          success: false,
          statusCode: statusCode,
          result: response.body,
          errorMessage: errorCodeNames[HTTP_CODE_BAD_RESPONSE],
        );
      }

      return APIResponse(
        success: true,
        statusCode: statusCode,
        result: response.body,
      );
    } on SocketException {
      return APIResponse(
        success: false,
        statusCode: HTTP_CODE_NO_INTERNET,
        result: '',
        errorMessage: errorCodeNames[HTTP_CODE_NO_INTERNET],
      );
    } on HttpException {
      return APIResponse(
        success: false,
        statusCode: HTTP_CODE_NOT_FOUND,
        result: '',
        errorMessage: errorCodeNames[HTTP_CODE_NOT_FOUND],
      );
    } on FormatException {
      return APIResponse(
        success: false,
        statusCode: HTTP_CODE_BAD_RESPONSE,
        result: '',
        errorMessage: errorCodeNames[HTTP_CODE_BAD_RESPONSE],
      );
    } on Exception catch (_) {
      return APIResponse(
        success: false,
        statusCode: HTTP_CODE_BAD_RESPONSE,
        result: '',
        errorMessage: errorCodeNames[HTTP_CODE_BAD_RESPONSE],
      );
    } catch (e) {
      return APIResponse(
        success: false,
        statusCode: HTTP_CODE_UNKNOWN,
        result: '',
        errorMessage: '${errorCodeNames[HTTP_CODE_UNKNOWN]}: $e',
      );
    }
  }

  Future<APIResponse> get(APIRequest request) => this.request(request);

  Future<APIResponse> post(APIRequest request) => this.request(request);

  Future<APIResponse> patch(APIRequest request) => this.request(request);

  Future<APIResponse> delete(APIRequest request) => this.request(request);
}
