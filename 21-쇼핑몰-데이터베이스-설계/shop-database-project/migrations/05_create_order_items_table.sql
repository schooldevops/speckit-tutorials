-- 05_create_order_items_table.sql
-- spec.md 와 constitution.md 명세 준수 (PostgreSQL, snake_case, 참조 무결성 혼합 적용, 타임스탬프)

CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키(Foreign Key) 설정 및 참조 무결성 적용 (CASCADE / RESTRICT 혼합)
    -- 주문(orders)이 연쇄 삭제된다면 속한 물품 목록도 함께 삭제 처리 (ON DELETE CASCADE)
    CONSTRAINT fk_order_items_order_id
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,
        
    -- 기존 상품(products)이 시스템상 삭제(단종 등)되려 할 때, 이미 주문이 이뤄진 물품 기록이 
    -- 날아가는 것을 방지하기 위해 강제로 삭제를 차단 (ON DELETE RESTRICT)
    CONSTRAINT fk_order_items_product_id
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE RESTRICT
);

-- 타임스탬프 자동 갱신 트리거 부착 (공용 함수 재사용)
CREATE TRIGGER update_order_items_updated_at
BEFORE UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
