# 🚇 전도 파트너 플랫폼 (Evangelical Gospel Partner)

> **"당근처럼 친근하게, 지하철처럼 체계적으로"**
> 각 지역별 독립적인 브랜딩과 강력한 마스터 제어 기능을 제공하는 프리미엄 지역 통합 플랫폼입니다.

---

## ✨ 핵심 기능 하이라이트 (Feature Highlights)

### 🎨 노선별 동적 테마 (Dynamic Branding)
- **지하철 노선 아이덴티티**: 안국역(3호선-주황), 삼성역(2호선-연두), 판교역(신분당선-빨강) 등 각 지역의 상징색과 역명판 디자인이 앱 전체에 실시간 반영됩니다.
- **WOW 디자인**: 현대적인 글래스모피즘(Glassmorphism)과 매끄러운 애니메이션이 적용된 프리미엄 UI/UX.

### 🏢 지능형 멀티 테넌트 (Multi-tenant Architecture)
- **독립 테이블 구조**: 구역별로 사용자 데이터를 분리 관리하여 보안과 독립성을 보장합니다.
- **다중 구역 가입**: 한 명의 사용자가 여러 구역의 파트너로 활동할 수 있으며, 각 구역의 DB에 계정 정보가 안전하게 동기화됩니다.

### 🛡️ 마스터 관리자 시스템 (Admin Master Panel)
- **통합 관제**: 모든 구역의 사용자, 블랙리스트, 공지사항을 하나의 대시보드에서 통제합니다.
- **블랙리스트 제어**: 부적절한 사용자를 즉시 전역/지역별로 차단하고 관리할 수 있습니다.
- **강력한 보안**: 7일 단위 PITR(Point-in-Time Recovery) 및 매일 자정 자동 백업 시스템 구축.

---

## 📱 사용자 여정 가이드 (User Journey Walkthrough)

전도 파트너 플랫폼의 핵심 사용자 여정을 단계별로 안내합니다.

### 1. 시작 및 로그인 (Landing & Login)
![시작 화면](docs/screenshots/01_landing_page.png)
*   **Google로 시작하기**: 별도의 복잡한 가입 절차 없이 구글 계정으로 즉시 시작할 수 있습니다.

### 2. 지역 선택 및 회원가입 (Signup & Region Selection)
![회원가입 화면](docs/screenshots/02_signup_page.png)
*   **소속 선택**: 가입 시 본인이 활동할 지역(테넌트)을 선택합니다. 선택한 지역에 따라 앱의 테마 색상과 로고가 자동으로 설정됩니다.

### 3. 홈 화면 및 지역별 브랜딩 (Dynamic Branding)
![안국역 테마](docs/screenshots/03_home_ankuk.png)
*   **안국역 파트너**: 3호선의 주황색 테마와 역명판 스타일의 상단 이미지가 적용된 모습입니다.

### 4. 당근 스타일 지역 전환 (Region Switcher)
![지역 전환 팝업](docs/screenshots/04_region_switcher.png)
*   **간편한 전환**: 상단 왼쪽의 지역명을 클릭하면 하단 시트가 나타나며, 다른 지역의 소식을 궁금해할 때 언제든 간편하게 이동할 수 있습니다.

---

## 🛠️ 기술적 세부 사항 (Technical Details)

### 🔒 보안 및 환경 설정
*   **PITR 및 백업**: 랜섬웨어 등 보안 사고에 대비한 [백업 및 복구 가이드](docs/BACKUP_AND_RESTORE.md)를 참고하세요.
*   **민감 정보**: API 키 및 키스토어는 깃허브에 공유되지 않으며, `99.Secrets/` 폴더를 통해 로컬에서 관리됩니다.

### 🧪 테스트 및 배포
*   **단위 테스트**: `flutter test test/unit/tenant_provider_test.dart`
*   **자동 배포**: GitHub Actions를 통해 웹(GitHub Pages) 및 안드로이드(AAB) 빌드가 자동 수행됩니다.

---

## 🚀 업데이트 내역 (Antigravity Agent)
- **Admin Dashboard**: 통합 관리 기능 및 블랙리스트 탭 추가.
- **Multi-Tenant Sync**: 사용자 정보의 구역별 독립 테이블 동기화 로직 구현.
- **UI/UX**: 노선별 컬러 시스템 및 로그아웃 기능 강화.
