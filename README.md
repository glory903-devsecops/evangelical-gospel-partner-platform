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
