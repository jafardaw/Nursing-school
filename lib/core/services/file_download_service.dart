import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class FileDownloadService {
  /// 🟢 تحميل ملف PDF للويب
  static void downloadPdf({
    required Uint8List bytes,
    String fileName = 'document.pdf',
  }) {
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
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