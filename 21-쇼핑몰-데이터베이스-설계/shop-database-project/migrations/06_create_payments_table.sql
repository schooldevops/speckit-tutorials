-- 06_create_payments_table.sql
-- spec.md 와 constitution.md 명세 준수 (PostgreSQL, snake_case, 결제 보존을 위한 참조 무결성 통제, 타임스탬프)

CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT '결제 대기',
    paid_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키(Foreign Key) 설정 및 규칙 적용
    -- 금융 결제가 속한 원본 주문 내역은 데이터베이스에서 물리적으로 사라져선 안 되므로 엄격히 차단 (ON DELETE RESTRICT)
    CONSTRAINT fk_payments_order_id
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE RESTRICT
);

-- 타임스탬프 자동 갱신 트리거 부착 (1번 태스크에서 생성된 공용 함수 재사용)
CREATE TRIGGER update_payments_updated_at
BEFORE UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
