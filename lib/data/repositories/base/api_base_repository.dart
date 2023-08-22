import 'dart:io' show HttpStatus;

import 'package:dcs_app/utils/data_convert_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

import '../../../utils/resouces/data_state.dart';

abstract class BaseApiRepository {
  /// This method is responsible of handling the given `request`, in which
  /// it returns generic based `DataState`.
  ///
  /// Returns `DataSuccess` that holds the generic data `T` if the response
  /// is successfully recieved.
  ///
  /// Returns `DataFailed` that holds a `DioError` instance if any error occurs
  /// while sending the request or recieving the response.
  @protected
  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<T>(httpResponse.data);
      } else {
        throw DioException(
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
        );
      }
    } on DioException catch (error) {
      return DataFailed(errorMessage: DataConvertUtils.catchMessage(error));
    }
  }
}
