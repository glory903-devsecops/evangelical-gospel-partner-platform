# 12. 개발 환경 설정 가이드 (Windows용)

이 문서는 코딩 지식이 없는 사용자도 Windows PC에서 Flutter 개발 환경을 구축할 수 있도록 돕습니다.

## 0. 현재 PC 환경 점검 결과 (Checklist)
- [x] **Git**: 설치됨 (v2.53.0)
- [x] **Node.js**: 설치됨 (v24.14.1)
- [x] **Docker**: 설치됨 (확인 완료)
- [ ] **Flutter SDK**: 설치 필요
- [ ] **Java/Android Studio**: 설치 필요

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
