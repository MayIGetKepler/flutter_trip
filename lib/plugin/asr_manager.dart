import 'package:flutter/services.dart';
import 'dart:async';

const _ASR_CHANNEL = 'asr_plugin';

class AsrManager {
  static const MethodChannel _methodChannel = MethodChannel(_ASR_CHANNEL);

  ///开始录音
  static Future<String> start({Map params}) async{
   return  _methodChannel.invokeMethod("start",params ?? {});
  }

  ///停止录音
  static Future<String> stop() async{
    return  _methodChannel.invokeMethod("stop");
  }

  ///取消录音
  static Future<String> cancel() async{
    return  _methodChannel.invokeMethod("cancel");
  }

  ///释放资源
  static Future<String> release() async{
    return  _methodChannel.invokeMethod("release");
  }


}
