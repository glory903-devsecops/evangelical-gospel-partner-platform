# 🍎 iOS Setup Guide for Mac (Antigravity Agent Mandate)

이 문서는 Mac 환경에서 Antigravity AI 에이전트가 iOS 배포 환경을 구축하기 위한 지침서입니다. 맥 에이전트는 이 파일을 읽고 아래 절차를 수행하십시오.

## ⚠️ AI 에이전트 사전 주의사항
1.  **Firebase Config**: `ios/Runner/GoogleService-Info.plist` 파일이 이미 프로젝트에 포함되어 있습니다.
2.  **Flutter SDK**: 맥에 Flutter SDK가 설치되어 있지 않다면 먼저 설치하십시오.
3.  **CocoaPods**: 의존성 관리를 위해 CocoaPods가 필요합니다.

---

## 🛠️ Mac 에이전트 수행 절차

### 1. 의존성 설치 (터미널 작업)
에이전트는 다음 명령어를 순서대로 실행하십시오.
```bash
# CocoaPods 설치 확인 및 설치
if ! command -v pod &> /dev/null; then
    sudo gem install cocoapods
fi

# Flutter 패키지 가져오기
flutter pub get

# iOS Pod 설치
cd ios
pod install
cd ..
```

### 2. Xcode 프로젝트 설정 도움
에이전트는 사용자에게 다음 수동 작업을 요청하거나, 가능하다면 Xcode 설정을 지원하십시오.
- `ios/Runner.xcworkspace` 파일을 Xcode로 엽니다.
- **Signing & Capabilities** 섹션에서 사용자의 **Apple ID Team**을 설정합니다.
- **Bundle Identifier**가 `com.glory903.egpp.evangelical-gospel-partner`와 일치하는지 확인합니다.

### 3. 빌드 및 테스트
설정이 완료되면 시뮬레이터나 연결된 기기에서 다음 명령어로 앱을 실행하십시오.
```bash
flutter run
```

---
*Created by Antigravity (Windows Session)*
