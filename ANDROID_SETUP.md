# 🤖 Android Setup & Build Guide (Windows/Mac)

이 문서는 안드로이드(Android) 앱의 빌드 및 배포를 위한 로컬 환경 구성과 빌드 방법 안내입니다.

## 1. 사전 요구사항 (Prerequisites)

안드로이드 앱을 빌드하기 위해 아래 도구들이 올바르게 설치되어 있어야 합니다. (상세 내역은 `12_ENVIRONMENT_SETUP.md` 참고)
*   **Flutter SDK** (v3.18.0 이상 권장)
*   **Android SDK & Command-line Tools** (Android Studio를 통해 설치)
*   **Java Development Kit (JDK)**: OpenJDK 17 버전 (Android Gradle Plugin 8.x 이상 지원용)

## 2. 보안 키스토어 및 서명 설정 (Signing Configuration)

보안과 배포 자동화를 위해 프로젝트 루트 아래의 `99.Secrets` 및 `android` 폴더에서 서명 키 정보를 관리합니다.

1.  **자격 증명 확인**: `99.Secrets/SECURITY_CREDENTIALS.md` 파일에 비밀번호 및 별칭(Alias)이 기재되어 있습니다.
2.  **키스토어 파일 위치**: `android/app/upload-keystore.jks` 파일이 존재해야 합니다. (이미 프로젝트에 포함되어 있습니다.)
3.  **key.properties 생성**: `android/key.properties` 파일이 설정되어 있어야 빌드 시 서명이 자동 적용됩니다. (로컬 전용 파일로, 깃허브에는 공유되지 않습니다.)
    *   **형식**:
        ```properties
        storePassword=egpp2026!
        keyPassword=egpp2026!
        keyAlias=upload
        storeFile=../upload-keystore.jks
        ```

## 3. 안드로이드 빌드 명령어

빌드 작업은 파일 쓰기 권한 및 빌드 캐시 안정성을 위해 NTFS 포맷의 로컬 드라이브(예: `C:\src\evangelical-gospel-partner-platform`)에서 수행할 것을 강력히 권장합니다.

### 3.1 APK 빌드 (테스트용)
테스트 기기에 설치할 단일 APK 파일을 생성합니다.
```bash
flutter build apk --release
```
*   **결과물 경로**: `build/app/outputs/flutter-apk/app-release.apk`

### 3.2 App Bundle (AAB) 빌드 (구글 플레이 스토어 배포용)
구글 플레이 콘솔에 업로드할 배포용 번들을 생성합니다.
```bash
flutter build appbundle --release
```
*   **결과물 경로**: `build/app/outputs/bundle/release/app-release.aab`

## 4. 트러블슈팅 (Troubleshooting)

### JDK 버전 오류 (Unsupported class file major version)
*   **현상**: Gradle 빌드 중 Java 버전 관련 컴파일 에러 발생.
*   **해결**: 환경 변수의 `JAVA_HOME`이 **JDK 17**로 설정되어 있는지 확인하십시오. (Android Studio의 내장 JDK를 가리키거나 Microsoft OpenJDK 17 경로로 지정)

### Google Services JSON 파일 누락
*   **현상**: `com.google.gms.google-services` 플러그인 컴파일 실패.
*   **해결**: Firebase 콘솔에서 다운로드한 `google-services.json` 파일이 `android/app/` 폴더에 있는지 확인하십시오. (이미 배치 완료됨)
