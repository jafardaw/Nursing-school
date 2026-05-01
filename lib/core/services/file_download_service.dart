import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class FileDownloadService {
  /// 🟢 تحميل ملف للويب
  static void downloadFile({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/pdf',
  }) {
    if (kIsWeb) {
      // للويب - استخدام anchor tag
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    }
  }
}
