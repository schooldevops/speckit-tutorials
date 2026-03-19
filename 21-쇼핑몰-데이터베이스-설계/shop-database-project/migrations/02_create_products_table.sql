-- 02_create_products_table.sql
-- spec.md 와 constitution.md 명세 준수 (PostgreSQL, snake_case 병합, 타임스탬프 등)

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    name VARCHAR(255) NOT NULL,
    price NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    stock INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- [PostgreSQL 특화 기능 로직 적용]
-- 01_create_users_table.sql 에서 선언해둔 타임스탬프 자동 갱신 공용 함수(update_updated_at_column)를 활용하여 트리거만 부착합니다.
CREATE TRIGGER update_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();