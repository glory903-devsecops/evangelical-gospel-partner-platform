# Firestore 백업 및 복구 가이드 (Ransomware 대비)

본 가이드는 서버 데이터 오염이나 실수로 인한 데이터 삭제 시 시스템을 안전하게 복원하기 위한 절차를 설명합니다.

## 1. PITR (Point-in-Time Recovery) 활성화
PITR을 활성화하면 지난 7일 이내의 **어느 시점(초 단위)**으로든 DB를 즉시 복구할 수 있습니다.

- **설정 방법**:
  1. Google Cloud Console 접속
  2. Firestore > Settings 메뉴 이동
  3. 'Point-in-Time Recovery' 활성화 (7일 보관)

## 2. 매일 00시 자동 백업 (Scheduled Export)
데이터를 외부 저장소(Cloud Storage)에 매일 자동으로 백업하여 영구 보관합니다.

### A. 백업용 버킷 생성
```bash
gsutil mb -l asia-northeast3 gs://egp-platform-backups
```

### B. 클라우드 스케줄러 설정
Google Cloud Scheduler를 사용하여 매일 자정에 아래 명령어를 실행하도록 설정합니다.
- **빈도**: `0 0 * * *` (매일 자정)
- **대상**: Firestore API (Export)

## 3. 데이터 복구 절차
데이터 오염 시 가장 최근의 자정(00시) 백업본으로 복구하는 방법입니다.

### 복구 명령어
```bash
gcloud firestore import gs://egp-platform-backups/[BACKUP_PATH]
```

## 4. 랜섬웨어 대응 수칙
1. **즉시 차단**: 이상 징후 발견 시 Firestore 보안 규칙에서 모든 쓰기(`allow write: if false;`)를 즉시 차단합니다.
2. **원인 분석**: 로그 탐색기(Cloud Logging)를 통해 비정상적인 접근이 발생한 API 키나 계정을 식별합니다.
3. **복구 실행**: 위 3번 절차에 따라 가장 안전한 최신 백업본으로 데이터를 복구합니다.
