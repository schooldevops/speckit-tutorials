-- 04_create_orders_table.sql
-- spec.md 와 constitution.md 명세 준수 (PostgreSQL, snake_case, 참조 무결성, 타임스탬프)

CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    total_price NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(50) NOT NULL DEFAULT '결제 대기',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키(Foreign Key) 설정 및 참조 무결성(ON DELETE RESTRICT) 적용
    -- 회원이 탈퇴(삭제)되어도 주문 내역은 회계상 보존되어야 하므로 연쇄 삭제가 발생하지 못하도록 엄격히 통제합니다.
    CONSTRAINT fk_orders_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT
);

-- 타임스탬프 자동 갱신 트리거 부착 (공용 함수 사용)
CREATE TRIGGER update_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
