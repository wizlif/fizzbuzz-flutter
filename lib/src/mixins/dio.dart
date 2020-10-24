import 'package:dio/dio.dart';

class DioErrorMixin {
  String handleError(DioError error) {
    String errorDescription = "";

    if (error?.response?.data != null) {
      errorDescription = error?.response?.data["message"];
    } else {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
          "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
          "Received invalid status code: ${error?.response?.statusCode}";
          break;
      }
    }

    return errorDescription;
  }

  void setupLoggingInterceptor(Dio _dio) {
    int maxCharactersPerLine = 200;

    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) {
        print("--> ${options.method} ${options.path}");
        print("Content type: ${options.contentType}");
        print("<-- END HTTP");
        return options;
      }, onResponse: (Response response) {
        logResponse(response, maxCharactersPerLine);
        return response; // continue
      }, onError: (DioError e) {
        // Do something with response error
        print("-- ERROR --");
        print("--> ${e.message} <--");
//        _logResponse(e.response, maxCharactersPerLine);
        return e; //continue
      }),
    );
  }

  void logResponse(Response response, int maxCharactersPerLine) {
    print(
        "<-- ${response?.statusCode} ${response?.request?.method} ${response?.request?.path}");
    String responseAsString = response?.data?.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        print(
            responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response?.data);
    }
    print("<-- END HTTP");
  }
}
