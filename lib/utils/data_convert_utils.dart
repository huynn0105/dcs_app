import 'package:dio/dio.dart';

class DataConvertUtils {
  static String catchMessage(DioException exception) {
    try {
      return exception.response?.data['message'] != null
          ? exception.response!.data['message']
          : (exception.message ?? '');
    } catch (e) {
      return exception.message ?? '';
    }
  }
}
