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

## 🔒 보안 및 환경 설정 (Security & Environment Setup)

본 프로젝트는 보안을 위해 민감한 정보를 공개 저장소(GitHub)에 포함하지 않습니다. 새로운 환경에서 프로젝트를 실행하려면 다음 설정이 필요합니다.

### 1. 민감 정보 관리 (Secrets)
*   **`.gitignore` 보호**: `99.Secrets/` 폴더와 `*.jks`, `key.properties` 파일은 버전 관리에서 제외됩니다.
*   **로컬 설정**: 프로젝트 루트에 `99.Secrets/` 폴더를 생성하고, `SECURITY_CREDENTIALS.md` 파일을 만들어 API 키, 키스토어 비밀번호 등을 기록해 두는 것을 권장합니다.

### 2. Firebase 설정
*   **`lib/firebase_options.dart`**: 이 파일은 파이어베이스 설정 정보(API Key, App ID 등)를 포함합니다. 깃허브에 공유되어도 되지만, 구글 클라우드 콘솔에서 **API 키 제한(HTTP referrers, Android App restrictions)**을 반드시 설정해야 어뷰징을 방지할 수 있습니다.
*   **Google Sign-in**: 구글 로그인을 위해 Firebase Console의 'Authentication' 메뉴에서 Google을 활성화하고, OAuth 클라이언트 ID를 확인하세요.

### 3. Android 배포를 위한 키 생성
*   릴리즈 빌드를 위해서는 `upload-keystore.jks` 파일이 필요합니다. 
*   `android/key.properties` 파일을 생성하여 키스토어 경로와 비밀번호를 로컬에서 관리하세요. (예시 코드는 `android/app/build.gradle` 참조)

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

---

## 🛠️ 주요 기능 및 아키텍처 (Key Features)

### 1. 운영자 마스터 패널 (Admin Master Panel)
관리자 전용 대시보드를 통해 플랫폼 전체를 제어할 수 있습니다.
*   **사용자 관리**: 전체 가입자 목록 조회 및 검색, 지역별 가입 현황 파악.
*   **블랙리스트 시스템**: 특정 사용자를 즉시 차단하고 사유를 기록하여 비정상적인 활동을 방지합니다.
*   **공지사항 통합 제어**: 각 지역별로 흩어진 공지사항을 한곳에서 모니터링하고 관리자가 직접 수정하거나 삭제할 수 있습니다.

### 2. 멀티 테넌트 데이터 구조 (Multi-tenant Architecture)
사용자가 여러 지역(안국, 다산, 삼성 등)의 파트너로 활동할 수 있도록 설계된 유연한 데이터 모델입니다.
*   **데이터 독립성**: 각 지역(Tenant)별로 `members` 서브 컬렉션을 두어 구역별 독립적인 운영이 가능합니다.
*   **데이터 동기화**: 사용자의 기본 프로필은 전역 테이블과 각 지역별 테이블에 실시간으로 동기화되어, 특정 지역의 데이터만 따로 관리하거나 백업하기 용이합니다.

### 3. 백업 및 보안 (Security & Backup)
랜섬웨어 및 데이터 유실 사고에 대비한 강력한 보호 장치를 갖추고 있습니다.
*   **7일 PITR**: 실수로 삭제된 데이터를 초 단위로 복구할 수 있는 Point-in-Time Recovery 시스템.
*   **매일 00시 자동 백업**: Cloud Storage를 활용한 일일 전체 백업 스케줄링.
*   **상세 가이드**: [백업 및 복구 매뉴얼](docs/BACKUP_AND_RESTORE.md) 제공.

---

## 📱 사용자 여정 가이드 (User Journey Walkthrough)

전도 파트너 플랫폼의 핵심 사용자 여정을 단계별로 안내합니다.

### 1. 시작 및 로그인 (Landing & Login)
![시작 화면](file:///C:/Users/LG-GLORY/.gemini/antigravity/brain/e48e6a05-ab45-41e5-9ac3-990088ccd4f8/01_landing_page_1777217056747.png)
*   **Google로 시작하기**: 별도의 복잡한 가입 절차 없이 구글 계정으로 즉시 시작할 수 있습니다.
*   **이메일 가입**: 기존 방식의 이메일/비밀번호 가입도 지원합니다.

### 2. 지역 선택 및 회원가입 (Signup & Region Selection)
![회원가입 화면](file:///C:/Users/LG-GLORY/.gemini/antigravity/brain/e48e6a05-ab45-41e5-9ac3-990088ccd4f8/02_signup_page_1777217063389.png)
*   **소속 선택**: 가입 시 본인이 활동할 지역(테넌트)을 선택합니다. 선택한 지역에 따라 앱의 테마 색상과 로고가 자동으로 설정됩니다.

### 3. 홈 화면 및 지역별 브랜딩 (Dynamic Branding)
![안국역 테마](file:///C:/Users/LG-GLORY/.gemini/antigravity/brain/e48e6a05-ab45-41e5-9ac3-990088ccd4f8/03_home_ankuk_1777217158920.png)
*   **안국역 파트너**: 3호선의 주황색 테마와 역명판 스타일의 상단 이미지가 적용된 모습입니다.
*   **실시간 정보**: 해당 지역의 최신 공지사항과 다가오는 행사를 한눈에 확인할 수 있습니다.

### 4. 당근 스타일 지역 전환 (Region Switcher)
![지역 전환 팝업](file:///C:/Users/LG-GLORY/.gemini/antigravity/brain/e48e6a05-ab45-41e5-9ac3-990088ccd4f8/04_region_switcher_1777217399711.png)
*   **간편한 전환**: 상단 왼쪽의 지역명을 클릭하면 하단 시트가 나타나며, 다른 지역의 소식을 궁금해할 때 언제든 간편하게 이동할 수 있습니다.

### 5. 다양한 노선 테마 적용 (Multi-Theme)
![삼성역 테마](file:///C:/Users/LG-GLORY/.gemini/antigravity/brain/e48e6a05-ab45-41e5-9ac3-990088ccd4f8/05_home_samseong_1777217519869.png)
*   **삼성역 파트너**: 지역을 전환하면 즉시 2호선의 연두색 테마로 앱 전체 분위기가 바뀝니다. 각 노선의 아이덴티티를 살린 디자인을 제공합니다.

### 6. 로그아웃 및 보안 (Logout & Security)
![로그아웃 아이콘](file:///C:/Users/LG-GLORY/.gemini/antigravity/brain/e48e6a05-ab45-41e5-9ac3-990088ccd4f8/06_logout_icon_1777217460542.png)
*   **빠른 로그아웃**: 우측 상단의 로그아웃 아이콘을 통해 언제든 안전하게 세션을 종료할 수 있습니다.

---

## 🧪 테스트 가이드 (Testing)

본 프로젝트는 코드의 안정성을 위해 단위 테스트와 통합 테스트를 포함하고 있습니다.

### 단위 테스트 (Unit Tests)
핵심 로직(테넌트 관리, 권한 제어 등)에 대한 검증을 수행합니다.
```bash
flutter test test/unit/tenant_provider_test.dart
```

### 통합 테스트 (User Journey Test)
브라우저 자동화를 통해 실제 사용자의 가입부터 지역 전환까지의 흐름을 시뮬레이션하고 검증했습니다. (Antigravity Agent 수행)

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
