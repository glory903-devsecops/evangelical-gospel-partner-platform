# 06. 기술 아키텍처

## 고정 기술 스택
- Frontend: Flutter
- Backend/BaaS: Firebase
- Auth: Firebase Authentication
- Database: Cloud Firestore
- File: Firebase Storage
- Server Logic: Cloud Functions for Firebase
- Web Hosting: Firebase Hosting

## 아키텍처 원칙
- React 사용 금지
- 하나의 코드베이스로 앱/웹 동시 대응
- 멀티테넌트 구조
- Firebase 중심 서버리스 구조
- 최소한의 운영 복잡도

## 테넌트 처리 방식
- 하나의 앱
- tenantId 기반 데이터 분리
- 테넌트별 설정값 분리
- 필요 시 서브도메인은 추후 검토

## 권장 디렉토리 구조 (예시)
lib/
  core/
  features/
    auth/
    home/
    notices/
    events/
    applications/
    admin/
    access_gate/
  models/
  services/
  repositories/
  widgets/
  routes/

## 상태관리
- 단순/안정적인 구조 우선
- Riverpod 또는 Provider 중 하나 택1
- 과한 복잡도 금지

## 우선 개발 원칙
- 기능 우선
- 디자인 과욕 금지
- 관리자 화면도 최소 기능으로 구현
