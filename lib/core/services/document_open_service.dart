import 'package:universal_html/html.dart' as html;

class DocumentOpenService {
  const DocumentOpenService._();

  static bool open(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;

    html.window.open(uri.toString(), '_blank');
    return true;
  }
}
