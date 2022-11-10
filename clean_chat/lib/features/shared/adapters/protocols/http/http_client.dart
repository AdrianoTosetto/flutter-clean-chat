import 'package:clean_chat/features/shared/adapters/protocols/http/http.dart';

abstract class HttpClient {
  Future<HttpResponse> request(HttpRequest request);
}
