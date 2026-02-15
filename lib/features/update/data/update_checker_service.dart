import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateCheckerService {
  Future<bool> isUpdateAvailable(String latestVersion) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    return _compareVersions(currentVersion, latestVersion) < 0;
  }

  int _compareVersions(String v1, String v2) {
    var v1Parts = v1.split('.').map(int.parse).toList();
    var v2Parts = v2.split('.').map(int.parse).toList();

    for (var i = 0; i < v1Parts.length; i++) {
      if (v2Parts.length < i + 1) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  Future<void> launchUpdateUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
