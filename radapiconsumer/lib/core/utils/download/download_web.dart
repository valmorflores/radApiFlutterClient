import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DownloadWeb {
  final imgUrl =
      "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
  var dio = Dio();

  void download(String url, String savePath) async {
    try {
      debugPrint('f7401 - Acionando dio for get url ${url}');

      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return (status! < 500);
            }),
      );

      debugPrint(response.headers.toString());
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      debugPrint('f7401 - Complete in: ${savePath}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showDownloadProgress(received, total) {
    /*if (total != -1) {
      debugPrint((received / total * 100).toStringAsFixed(0) + "%");
    }*/
  }
}
