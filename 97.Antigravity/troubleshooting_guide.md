# GitHub Actions 트러블슈팅 가이드

이 문서는 프로젝트 개발 중 발생하는 GitHub Actions 배포 및 빌드 실패 사례와 해결 방법을 정리한 가이드라인입니다.

## 1. 주요 실패 사례 및 원인

### A. 빌드 실패 (Compilation Error)
*   **증상**: `Build Web` 또는 `Build APK` 단계에서 `exit code 1`과 함께 종료.
*   **원인**: 
    *   코드 내 문법 오류 (Syntax Error).
    *   Null Safety 위반 (Nullable 변수에 대한 부적절한 접근).
    *   미사용 임포트(Unused Import)가 CI 설정에 따라 에러로 처리됨.
*   **해결 방법**:
    *   푸시 전 반드시 `flutter build web --release`를 로컬에서 실행해 봅니다.
    *   `flutter analyze`를 실행하여 모든 `error`를 해결합니다.

### B. 보안 정책 위반 (SHA Pinning)
*   **증상**: `Set up job` 단계에서 실패하거나 보안 경고 발생.
*   **원인**: GitHub Actions 워크플로우 파일(.yml)에서 `uses: actions/checkout@v4`와 같이 버전 태그를 사용할 경우, 보안을 위해 40자리 커밋 SHA(예: `@34e11...`)를 사용하도록 강제됨.
*   **해결 방법**:
    *   워크플로우 파일의 모든 `uses:` 항목을 최신 커밋 SHA로 고정(Pinning)합니다.

### C. 의존성 충돌 (Dependency Conflict)
*   **증상**: `Get dependencies` 단계에서 `pubspec.yaml`의 버전 충돌 발생.
*   **원인**: 특정 패키지의 버전이 서로 호환되지 않거나, 웹 플랫폼(`firebase_auth_web` 등) 전용 패키지 버전이 맞지 않음.
*   **해결 방법**:
    *   `pubspec.yaml`에서 충돌하는 패키지 버전을 `any`로 일시 변경하거나 최신 버전으로 일관되게 맞춥니다.
    *   `flutter pub upgrade` 후 `pubspec.lock`을 함께 커밋합니다.

## 2. 권장 개발 프로세스

1.  **로컬 검증**: 푸시 전 로컬 터미널에서 다음 명령어를 순차적으로 실행하여 검증합니다.
    ```bash
    flutter clean
    flutter pub get
    flutter analyze
    flutter build web --release
    ```
2.  **커밋 메시지**: 작업 내용을 명확히 적어 나중에 로그를 확인할 때 어떤 작업에서 문제가 생겼는지 알 수 있게 합니다.
3.  **워크플로우 관리**: `.github/workflows/` 파일 수정 시에는 항상 기존에 성공했던 SHA 값을 참고하여 작성합니다.

## 3. 유용한 링크
*   [GitHub Actions 로그 확인](https://github.com/glory903-devsecops/evangelical-gospel-partner-platform/actions)
*   [Flutter Web 빌드 문서](https://docs.flutter.dev/deployment/web)

---
*Last Updated: 2026-04-30*
