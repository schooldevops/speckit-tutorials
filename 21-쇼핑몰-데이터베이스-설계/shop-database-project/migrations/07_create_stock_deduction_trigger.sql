-- 07_create_stock_deduction_trigger.sql
-- spec.md 데이터 모델 요구사항: "결제가 완료되면(Payment) 주문 상태 속성이 '결제 완료'로 변경되며 상품의 재고가 차감된다."

-- 1. 결제 완료 이벤트를 감지하여 원자적으로 재고 차감을 수행하는 스토어드 함수
CREATE OR REPLACE FUNCTION deduct_stock_on_payment_complete()
RETURNS TRIGGER AS $$
DECLARE
    cur_item RECORD;
BEGIN
    -- 결제의 상태가 새로 생성되었거나, 기존 상태에서 '결제 완료'로 업데이트 되었을 때만 작동
    IF NEW.status = '결제 완료' AND (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.status != '결제 완료')) THEN
        
        -- 새 결제에 묶인(order_id) 모든 상품의 장바구니/주문 물품 내역을 탐색
        FOR cur_item IN 
            SELECT product_id, quantity 
            FROM order_items 
            WHERE order_id = NEW.order_id
        LOOP
            -- 제품의 재고를 차감합니다. 
            UPDATE products
            SET stock = stock - cur_item.quantity
            WHERE id = cur_item.product_id;
        END LOOP;
        
        -- 요구사항에 의해 부모 테이블인 orders의 상태도 '결제 완료'로 일괄 동기화
        UPDATE orders
        SET status = '결제 완료'
        WHERE id = NEW.order_id;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. payments 테이블에 상태 변경 감지 트리거 부착 (DB 레벨의 무결성 보장 방식)
CREATE TRIGGER trigger_deduct_stock_on_payment
AFTER INSERT OR UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION deduct_stock_on_payment_complete();
