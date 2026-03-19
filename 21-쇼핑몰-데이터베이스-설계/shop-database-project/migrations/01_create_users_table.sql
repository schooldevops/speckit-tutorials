-- 01_create_users_table.sql
-- spec.md 와 constitution.md 명세 준수 (PostgreSQL, snake_case, 타임스탬프 등)

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =============== [PostgreSQL 특화 기능 로직] ===============
-- 사유(Reason): MySQL 등과 달리 PostgreSQL은 레코드 업데이트 시 `updated_at` 타임스탬프를 
-- 자동으로 갱신(ON UPDATE CURRENT_TIMESTAMP)해 주는 내장 DDL 구문 특성이 없습니다.
-- 따라서 모든 데이터베이스 레벨에서 `updated_at`의 최신화를 완벽하게 보장하려면 
-- 반드시 1) 갱신용 공용 함수와 2) 각 테이블별 트리거를 수동 구성해야 합니다.
-- 이를 통해 서버 로직(Backend ORM 등)이 타임스탬프 갱신을 누락하는 휴먼 에러를 원천 차단합니다.

-- 1. 타임스탬프 자동 갱신 트리거 함수 (이후 다른 테이블에서도 공용으로 재사용)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 2. users 테이블 전용 업데이트 트리거 부착
CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
