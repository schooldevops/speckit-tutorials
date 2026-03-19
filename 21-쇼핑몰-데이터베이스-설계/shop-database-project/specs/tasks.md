# 데이터베이스 스키마 구현 태스크 (Small Units)

본 태스크는 `data-model.md`의 구조를 가장 안전하고 작은 단위로 실제 PostgreSQL DB 스키마 코드로 구현하기 위한 체크리스트입니다. 상위 의존성을 먼저 처리하도록 순차 정렬되었습니다.

- [x] 1. **`users` 테이블 생성 SQL 작성** (컬럼: id, name, email, password, joined_at, timestamp)
   > *구현 요구사항*: PostgreSQL 환경에서는 `updated_at` 타임스탬프의 자동 갱신을 위해 DB 레벨의 트리거(Trigger)와 스토어드 함수가 필수적으로 요구됨. 따라서 테이블 설계 시 사유를 명시하고 공용 갱신 함수를 함께 작성할 것.
- [x] 2. **`products` 테이블 생성 SQL 작성** (컬럼: id, name, price, stock, description, timestamp)
- [x] 3. **`carts` 테이블 생성 SQL 작성** (컬럼: id, quantity, timestamp 및 user_id, product_id `ON DELETE CASCADE` 외래키 포함)
- [x] 4. **`orders` 테이블 생성 SQL 작성** (컬럼: id, total_price, status, timestamp 및 user_id `ON DELETE RESTRICT` 외래키 포함)
- [x] 5. **`order_items` 테이블 생성 SQL 작성** (컬럼: id, quantity, unit_price, timestamp 및 order_id CASCADE, product_id RESTRICT 외래키 포함)
- [x] 6. **`payments` 테이블 생성 SQL 작성** (컬럼: id, status, paid_at, timestamp 및 order_id `ON DELETE RESTRICT` 외래키 포함)
- [x] 7. **재고 차감 검토 (선택 사항)** 결제 완료 시 작동할 DB 함수(Function) 및 트리거(Trigger) 구현 스크립트 분리 혹은 명세.
