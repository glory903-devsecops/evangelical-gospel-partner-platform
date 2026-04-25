# 전도 파트너 플랫폼 프로젝트 문서 세트

이 폴더는 **Flutter + Firebase 기반 멀티테넌트 전도 파트너 웹/앱**을 코딩 에이전트(안티그래비티 등)에게 맡기기 위해 필요한 기본 문서들을 모아둔 프로젝트 스타터 문서 세트입니다.

## 프로젝트 목표
- 하나의 엔진(백엔드)으로 4개 지역 플랫폼 운영
- 테넌트:
  - 안국역 전도 파트너
  - 삼성역 전도 파트너
  - 판교역 전도 파트너
  - 다산역 전도 파트너
- 기술 스택:
  - Flutter (iPhone / Android / Web)
  - Firebase (Auth / Firestore / Storage / Functions / Hosting)
- 목적:
  - 비영리 운영
  - 1인 운영 가능한 구조
  - 최소 기능 MVP 우선
  - 상용 서비스 수준의 안정적 UX 지향

## 문서 목록
- `01_PROJECT_BRIEF.md` : 프로젝트 개요
- `02_PRODUCT_REQUIREMENTS_PRD.md` : 제품 요구사항 문서
- `03_INFORMATION_ARCHITECTURE.md` : 메뉴 및 화면 구조
- `04_FIREBASE_DATA_MODEL.md` : Firestore 데이터 구조 초안
- `05_ACCESS_CONTROL_GATE.md` : 동시 접속 제한 설계
- `06_TECHNICAL_ARCHITECTURE.md` : 기술 아키텍처
- `07_DEVELOPMENT_RULES.md` : 코딩 에이전트 작업 규칙
- `08_AGENT_MASTER_PROMPT.md` : 코딩 에이전트용 메인 프롬프트
- `09_TASK_BREAKDOWN.md` : 개발 단계별 작업 분해
- `10_ACCEPTANCE_CHECKLIST.md` : 결과 검수 체크리스트
- `11_COPY_GUIDE.md` : 기본 문구/카피 초안
- `12_ENVIRONMENT_SETUP.md` : 개발 환경 및 Firebase 설정 요청서

## 권장 사용 순서
1. `01_PROJECT_BRIEF.md` 공유
2. `02_PRODUCT_REQUIREMENTS_PRD.md` 공유
3. `06_TECHNICAL_ARCHITECTURE.md` 공유
4. `08_AGENT_MASTER_PROMPT.md`를 그대로 입력
5. `09_TASK_BREAKDOWN.md` 기준으로 단계별 개발 요청
6. 산출물 완료 시 `10_ACCEPTANCE_CHECKLIST.md`로 검수

---

## 로컬 실행 가이드 (Docker)

본 프로젝트는 일관된 개발/테스트 환경을 위해 Docker 컨테이너 기반으로 구동됩니다.

### 1. 웹 앱 빌드
컨테이너 실행 전 최신 소스코드를 빌드해야 합니다.
```bash
flutter build web --release
```

### 2. Docker 컨테이너 실행
Docker Compose를 사용하여 서버를 구동합니다.
```bash
# 컨테이너 빌드 및 실행 (백그라운드)
docker-compose up -d --build

# 실행 확인
docker ps
```

### 3. 접속 정보
*   **URL**: `http://localhost:5000`
*   **특징**: Nginx 기반의 SPA 라우팅이 설정되어 있어 직접 URL 입력(Deep Link) 시에도 정상적으로 작동합니다.

---

## 🚀 배포 및 업데이트 내역 (Antigravity)

최근 보안 규칙 적용 및 배포 파이프라인(CI/CD) 구축 내역입니다. (2026.04)

### 1. Web 앱 배포 완료 (GitHub Pages)
- **데모 사이트 복구**: `actions/upload-artifact@v4`의 보안(SHA 고정) 정책 위반을 해결하기 위해 `peaceiris/actions-gh-pages`로 워크플로우를 전면 교체했습니다. (`.github/workflows/gh-pages.yml`)
- **컴파일 오류 해결**: `auth_actions_provider.dart`, `home_page.dart`, `tenant_select_page.dart` 등에서 발생하던 웹 빌드 에러를 모두 수정했습니다.
- **결과**: 현재 [데모 사이트](https://glory903-devsecops.github.io/evangelical-gospel-partner-platform/)에 정상적으로 Flutter 앱이 렌더링되고 있습니다.

### 2. 보안 정책 강화 및 QA 절차 수립
- **에이전트 행동 지침**: `97.Antigravity/QA_PROCEDURE.md`를 신규 생성하여, 향후 AI 에이전트들이 코드 푸시 전 반드시 린트 에러와 빌드를 확인하도록 의무화했습니다.

### 3. 모바일(Android/iOS) 앱 배포 환경 구축
- **Mac iOS 가이드**: `MAC_IOS_SETUP.md`를 생성하여 Mac 환경의 다른 에이전트나 개발자가 바로 `pod install` 및 Xcode 서명을 수행할 수 있도록 안내서를 작성했습니다.
- **Android 자동 빌드 워크플로우**:
  - `android-build.yml`: 메인 브랜치 푸시마다 테스트용 디버그 APK(`app-debug.apk`)를 자동 생성.
  - `android-release.yml`: 구글 플레이 스토어 배포용 정식 App Bundle(`.aab`) 자동 생성.
- **Android Release 트러블슈팅**:
  - 구글 스토어용 릴리즈 빌드에 필요한 `key.properties` 참조 코드 중, Kotlin DSL 문법(`java.util.Properties` 패키지 참조 및 `it` 변수 참조 오류) 충돌 문제를 완전히 해결했습니다.
  - GitHub CLI를 통해 직접 리포지토리 Secrets(`ANDROID_KEYSTORE_BASE64` 등)를 주입하여 자동화된 앱 배포 기반을 완성했습니다.
