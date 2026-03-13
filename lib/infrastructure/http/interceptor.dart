class RequestInterceptor {
  void onRequest(Map<String, dynamic> headers) {
    headers['X-Client-Version'] = '1.0.0';
    headers['X-Request-Time'] = DateTime.now().toIso8601String();
    print('🔵 Request intercepted: ${headers['X-Request-Time']}');
  }
}

class ResponseInterceptor {
  void onResponse(int statusCode, Map<String, dynamic> body) {
    print('🟢 Response: $statusCode at ${DateTime.now().toIso8601String()}');
  }

  void onError(int statusCode, String error) {
    print('🔴 Error: $statusCode - $error at ${DateTime.now().toIso8601String()}');
  }
}

class HttpClient {
  final RequestInterceptor requestInterceptor;
  final ResponseInterceptor responseInterceptor;

  HttpClient({
    RequestInterceptor? requestInterceptor,
    ResponseInterceptor? responseInterceptor,
  })  : requestInterceptor = requestInterceptor ?? RequestInterceptor(),
        responseInterceptor = responseInterceptor ?? ResponseInterceptor();

  Future<Map<String, dynamic>> get(
    String url,
    Map<String, String> headers,
  ) async {
    requestInterceptor.onRequest(headers);
    responseInterceptor.onResponse(200, {});
    return {};
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, String> headers,
    Map<String, dynamic> body,
  ) async {
    requestInterceptor.onRequest(headers);
    responseInterceptor.onResponse(201, body);
    return body;
  }
}
