import 'dart:html' as html;

class UrlLauncherHelper {
  static Future<void> launchUrl(String url) async {
    html.window.open(url, '_blank');
  }
}
