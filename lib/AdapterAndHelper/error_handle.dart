/**
 *  error_handle.dart
 *
 *  Created by iotjin on 2020/07/08.
 *  description:  异常处理
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'log_utils.dart';

typedef Fail = Function(int code, String msg);
class ExceptionHandle {
  static const int success = 200;
  static const int success_not_content = 204;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int timeout_error = 1004;
  static const int cancel_error = 1005;
  static const int unknown_error = 9999;

  static NetError handleException(DioError error) {
    if (error is DioError) {
      if (error.type == DioErrorType.DEFAULT ||
          error.type == DioErrorType.RESPONSE) {
        dynamic e = error.error;
        if (e is SocketException) {
          return NetError(socket_error, '网络异常，请检查你的网络！');
        }
        if (e is HttpException) {
          return NetError(http_error, '服务器异常！');
        }
        if (e is FormatException) {
          return NetError(parse_error, '数据解析错误！');
        }
        return NetError(net_error, '网络异常，请检查你的网络！');
      } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          error.type == DioErrorType.SEND_TIMEOUT ||
          error.type == DioErrorType.RECEIVE_TIMEOUT) {
        //  连接超时 || 请求超时 || 响应超时
        return NetError(timeout_error, '连接超时！');
      } else if (error.type == DioErrorType.CANCEL) {
        return NetError(cancel_error, '取消请求');
      } else {
        return NetError(unknown_error, '未知异常');
      }
    } else {
      return NetError(unknown_error, '未知异常');
    }
  }

  static void onError(int code, String msg, Fail fail,BuildContext context) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    LogUtils.print_('接口请求异常： code: $code, msg: $msg');
    if (fail != null) {
      fail(code, msg);
    }
    Toast.show('接口请求异常： code: $code, msg: $msg', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}

class NetError {
  int code;
  String msg;

  NetError(this.code, this.msg);
}

