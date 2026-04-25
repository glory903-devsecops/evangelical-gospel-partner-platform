# 12. 개발 환경 설정 가이드 (Windows용)

본 문서는 전도 파트너 플랫폼 개발을 위한 Windows 환경 설정과 특별 작동 방식을 설명합니다.

## 🚩 중요: 윈도우 환경 특이사항 (구글 드라이브 사용자)

이 프로젝트를 **윈도우 PC**에서 **구글 드라이브(G: 등)** 위에 두고 개발할 경우, 다음과 같은 기술적 제약이 발생합니다.

### 1. 심볼릭 링크(Symlink) 이슈
윈도우의 구글 드라이브 가상 파일 시스템은 Flutter 빌드에 필요한 **심볼릭 링크(Reparse Point)** 생성을 지원하지 않습니다. 
- **현상**: `flutter pub get` 실행 시 `ERROR_INVALID_FUNCTION` 오류 발생.
- **해결책**: 실제 빌드 및 패키지 설치는 로컬 NTFS 드라이브(예: `C:\src`)에서 진행해야 합니다.

### 2. 권장 워킹 프로세스 (Worker Space 패턴)
- **보관 및 동기화 (Master)**: `g:\내 드라이브\99.Develop\evangelical-gospel-partner-platform`
  - 소스 코드 보관, 깃허브 푸시, 구글 드라이브 자동 백업용.
- **실제 작업 및 빌드 (Worker)**: `C:\src\evangelical-gospel-partner-platform`
  - 에이전트(Antigravity)가 코드를 이 폴더로 동기화하여 빌드 및 테스트를 수행.
- **이식성**: 이 패턴은 로컬 환경의 제약일 뿐이며, **GitHub**을 통해 소스 코드만 관리하므로 **맥(Mac)**이나 다른 PC로 이동 시 아무런 문제가 없습니다.

### 3. 서버 구동 및 도커(Docker) 활용 안내
- **현재 미사용 이유**: 본 프로젝트는 **Flutter Native** 및 **Firebase**의 성능을 최대로 활용하기 위해 로컬 SDK를 직접 사용합니다. 개발 단계(MVP)에서는 도커를 거치지 않는 것이 빌드 속도와 '핫 리로드' 측면에서 훨씬 유리합니다.
- **도커의 역할**: 추후 복잡한 백엔드 독립 서비스가 필요하거나, 배포 환경(CI/CD)을 표준화할 때 사용합니다. 사용자 PC의 도커는 이러한 확장성을 위해 준비된 상태입니다.

## 0. 현재 PC 환경 점검 결과 (Checklist)
- [x] **Git**: 설치됨 (v2.53.0)
- [x] **Node.js**: 설치됨 (v24.14.1)
- [x] **Docker**: 설치됨
- [x] **Flutter SDK**: 설치됨 (v3.41.6)
- [x] **Java (JDK)**: Microsoft OpenJDK 17 설치됨
- [x] **Firebase Tools**: v13.15.0 설치됨

---

## 1. Flutter SDK 설치

### 1.1 다운로드 및 압축 해제
1. [Flutter 공식 홈페이지](https://docs.flutter.dev/get-started/install/windows/desktop?tab=download)에 접속합니다.
2. 최신 안정 버전(Stable channel)의 ZIP 파일을 다운로드합니다.
3. `C:\src` 폴더를 새로 만들고, 그 안에 압축을 풉니다. (최종 경로: `C:\src\flutter`)
   - **주의**: `C:\Program Files` 폴더에는 절대로 설치하지 마세요. (권한 문제 발생)

### 1.2 환경 변수(Path) 설정
1. 윈도우 검색창에 **'시스템 환경 변수 편집'**을 입력하고 실행합니다.
2. 하단의 **[환경 변수]** 버튼을 클릭합니다.
3. '사용자 변수' 목록에서 **Path**를 선택하고 **[편집]**을 누릅니다.
4. **[새로 만들기]**를 누르고 `C:\src\flutter\bin`을 입력합니다.
5. 모든 창에서 확인을 눌러 닫습니다.

---

## 2. 필수 도구 설치

### 2.1 Android Studio (안드로이드 앱 빌드용)
1. [Android Studio 다운로드](https://developer.android.com/studio) 페이지로 이동합니다.
2. 설치 파일을 실행하고 기본값으로 설치를 완료합니다.
3. 설치 후 **[More Actions] -> [SDK Manager]**를 엽니다.
   - `Android SDK Command-line Tools (latest)` 항목을 찾아 체크하고 설치합니다.

### 2.2 Visual Studio Code (코드 편집기 - 선택 사항)
1. [VS Code 다운로드](https://code.visualstudio.com/) 후 설치합니다.
2. 좌측 테두리의 'Extensions' 아이콘을 누르고 `Flutter`를 검색하여 설치합니다.

---

## 3. 설치 확인

1. **PowerShell** 또는 **명령 프롬프트(CMD)**를 엽니다.
2. 아래 명령어를 입력합니다:
   ```powershell
   flutter doctor
   ```
3. 결과 화면에서 `[X]` 표시가 있는 항목이 있다면, 안티그래비티에게 해당 메시지를 복사해서 알려주세요.

---
*수정일: 2026-04-17 (Antigravity 작성)*
