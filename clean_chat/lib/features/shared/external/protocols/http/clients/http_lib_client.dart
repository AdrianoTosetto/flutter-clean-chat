import 'dart:convert';

import 'package:clean_chat/features/shared/adapters/protocols/http/http.dart';
import 'package:clean_chat/features/shared/adapters/protocols/http/http_client.dart';
import 'package:http/http.dart' as http_lib;

typedef HttpMethodHandler = Future<HttpResponse> Function(HttpRequest request);

class HttpLibClient extends HttpClient {
  @override
  Future<HttpResponse> request(HttpRequest request) async {
    String method = request.method;

    return await _methodHandlers[method]!(request);
  }

  final Map<String, HttpMethodHandler> _methodHandlers = {
    'post': (HttpRequest request) async {
      var encodedBodyRequest = json.encode(request.body);
      var headersRequest = request.headers;

      var response = await http_lib.post(
        Uri.parse(request.uri),
        body: encodedBodyRequest,
        headers: headersRequest,
      );

      var body = json.decode(response.body);
      var headers = json.decode(response.body);

      return HttpResponse(
        uri: request.uri,
        method: request.method,
        status: response.statusCode,
        body: body,
        headers: headers,
      );
    },
    'get': (HttpRequest request) async {
      var headersRequest = request.headers;

      var response = await http_lib.get(
        Uri.parse(request.uri),
        headers: headersRequest,
      );

      var responseBody = json.decode(response.body);
      var responseHeaders = json.decode(response.body);

      return HttpResponse(
        uri: request.uri,
        method: request.method,
        status: response.statusCode,
        body: responseBody,
        headers: responseHeaders,
      );
    }
  };
}
