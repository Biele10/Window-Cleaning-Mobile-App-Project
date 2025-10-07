import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class API {
  Dio api = Dio();
  String? access_token;
  final _storage = const FlutterSecureStorage();

  Api() {
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorisation'] = 'Bearer $access_token';
        },
      ),
    );
  }
}
