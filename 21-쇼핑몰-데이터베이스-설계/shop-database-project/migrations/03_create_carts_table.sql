-- 03_create_carts_table.sql
-- spec.md 와 constitution.md 명세 준수 (PostgreSQL, snake_case, 참조 무결성, 타임스탬프)

CREATE TABLE IF NOT EXISTS carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

-- 외래키(Foreign Key) 설정 및 참조 무결성(ON DELETE CASCADE) 적용
CONSTRAINT fk_carts_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
        
    CONSTRAINT fk_carts_product_id
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE
);

-- 01_create_users_table.sql 에서 선언해둔 타임스탬프 자동 갱신 공용 함수를 활용하여 트리거 부착
CREATE TRIGGER update_carts_updated_at
BEFORE UPDATE ON carts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();