# Database Constitution
1. 인프라: PostgreSQL 16 
2. 네이밍 컨벤션: 테이블명과 컬럼명은 반드시 `snake_case`로 통일한다.
3. 무결성 규칙: 삭제 시 외래키 참조 무결성을 위해 `ON DELETE CASCADE` 또는 `RESTRICT`를 조건에 맞게 명시한다.
4. 타임스탬프: 모든 테이블에는 `created_at`, `updated_at` 필드가 기본으로 존재해야 한다.
