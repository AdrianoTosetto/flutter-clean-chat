class HttpResponse {
  final String uri;
  final String method;
  final int status;
  final Map<String, dynamic> body;
  final Map<String, dynamic> headers;

  HttpResponse({
    required this.uri,
    required this.method,
    required this.status,
    this.body = const {},
    this.headers = const {},
  });
}

class HttpRequest {
  final String uri;
  final String method;
  final Map<String, dynamic> body;
  final Map<String, String> headers;

  HttpRequest({
    required this.uri,
    required this.method,
    this.body = const {},
    this.headers = const {},
  });
}
