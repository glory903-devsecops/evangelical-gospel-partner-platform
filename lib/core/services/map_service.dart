import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class MapService {
  /// 네이버 지도로 길찾기
  static Future<void> openNaverMap(String address, double? lat, double? lng) async {
    final url = lat != null && lng != null
        ? 'nmap://route/public?dlat=$lat&dlng=$lng&dname=${Uri.encodeComponent(address)}&appname=com.example.evangelical_gospel_partner'
        : 'nmap://search?query=${Uri.encodeComponent(address)}';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // 웹으로 열기
      final webUrl = 'https://map.naver.com/v5/search/${Uri.encodeComponent(address)}';
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  /// 카카오맵으로 길찾기
  static Future<void> openKakaoMap(String address, double? lat, double? lng) async {
    final url = lat != null && lng != null
        ? 'kakaomap://route?ep=$lat,$lng&by=PUBLICTRANSIT'
        : 'kakaomap://search?q=${Uri.encodeComponent(address)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      final webUrl = 'https://map.kakao.com/link/search/${Uri.encodeComponent(address)}';
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  /// TMap으로 길찾기
  static Future<void> openTMap(String address, double? lat, double? lng) async {
    final url = lat != null && lng != null
        ? 'tmap://route?goalx=$lng&goaly=$lat&goalname=${Uri.encodeComponent(address)}'
        : 'tmap://search?name=${Uri.encodeComponent(address)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // TMap은 웹 버전이 제한적이라 스토어 안내 또는 검색 결과
      final webUrl = 'https://search.naver.com/search.naver?query=${Uri.encodeComponent(address + " TMap")}';
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }
}
