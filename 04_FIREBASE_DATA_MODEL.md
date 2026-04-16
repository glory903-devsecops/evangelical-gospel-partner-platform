# 04. Firestore 데이터 모델 초안

## 컬렉션 개요
- tenants
- users
- notices
- events
- applications
- access_control
- operator_roles

## 1. tenants
문서 ID 예시: `anguk`, `samseong`, `pangyo`, `dasan`

필드 예시:
- name: string
- displayName: string
- isActive: boolean
- maxConcurrentUsers: number
- currentActiveUsers: number
- gateEnabled: boolean
- createdAt: timestamp
- updatedAt: timestamp

## 2. users
문서 ID: Firebase Auth uid

필드 예시:
- email: string
- name: string
- phone: string (optional)
- tenantId: string
- role: string (`user`, `operator`, `admin`)
- isActive: boolean
- createdAt: timestamp
- updatedAt: timestamp

## 3. notices
문서 ID 자동 생성

필드 예시:
- tenantId: string
- title: string
- content: string
- isPinned: boolean
- createdBy: uid
- createdAt: timestamp
- updatedAt: timestamp

## 4. events
문서 ID 자동 생성

필드 예시:
- tenantId: string
- title: string
- description: string
- location: string
- startAt: timestamp
- endAt: timestamp
- maxApplicants: number
- currentApplicants: number
- status: string (`open`, `closed`, `ended`)
- createdBy: uid
- createdAt: timestamp
- updatedAt: timestamp

## 5. applications
문서 ID 자동 생성

필드 예시:
- tenantId: string
- eventId: string
- userId: string
- status: string (`applied`, `cancelled`)
- appliedAt: timestamp
- updatedAt: timestamp

## 6. access_control
테넌트별 접속 제어 상태 저장

문서 ID 예시: tenantId

필드 예시:
- tenantId: string
- maxConcurrentUsers: number
- currentActiveUsers: number
- gateEnabled: boolean
- updatedAt: timestamp

## 7. operator_roles
문서 ID 자동 생성

필드 예시:
- tenantId: string
- userId: string
- role: string (`operator`)
- assignedBy: uid
- assignedAt: timestamp

## 보안 규칙 방향
- 사용자는 자기 tenantId 데이터만 조회 가능
- operator는 자기 tenantId의 notices/events/applications 관리 가능
- admin은 전체 관리 가능
