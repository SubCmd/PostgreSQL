-- ============================================================
-- 1) users : 회원 (가입·획득채널 정보)
-- ============================================================
CREATE TABLE users (
    user_id      SERIAL PRIMARY KEY,            -- 자동 증가 PK
    email        VARCHAR(255) UNIQUE NOT NULL,  -- 중복 불가 + 필수
    name         VARCHAR(100),
    signup_date  DATE NOT NULL,                 -- 가입일 (코호트 분석 기준)
    channel      VARCHAR(50),                   -- 획득채널: organic/paid/referral
    country      VARCHAR(50) DEFAULT 'KR',
    created_at   TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- 2) products : 상품 (가격·원가 → 마진 계산용)
-- ============================================================
CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    name         VARCHAR(200) NOT NULL,
    category     VARCHAR(50),                   -- 카테고리별 매출 분석
    price        NUMERIC(10,2) NOT NULL,        -- 판매가 (소수 둘째자리까지)
    cost         NUMERIC(10,2),                 -- 원가 (마진 = price - cost)
    created_at   TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- 3) orders : 주문 (헤더 — 누가/언제/상태)
-- ============================================================
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    user_id      INTEGER NOT NULL,
    order_date   DATE NOT NULL,
    status       VARCHAR(20) DEFAULT 'completed', -- completed/cancelled/refunded
    created_at   TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)  -- 관계 정의
);

-- ============================================================
-- 4) order_items : 주문 상세 (N:M 연결 테이블)
-- ============================================================
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INTEGER NOT NULL,
    product_id    INTEGER NOT NULL,
    quantity      INTEGER NOT NULL DEFAULT 1,
    unit_price    NUMERIC(10,2) NOT NULL,        -- 주문 시점 가격 (가격 변동 대비)
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_quantity CHECK (quantity > 0)  -- 수량은 항상 양수
);

-- ============================================================
-- 5) events : 사용자 행동 이벤트 (퍼널/리텐션 분석용)
-- ============================================================
CREATE TABLE events (
    event_id     SERIAL PRIMARY KEY,
    user_id      INTEGER NOT NULL,
    event_name   VARCHAR(50) NOT NULL,          -- page_view/add_to_cart/checkout/purchase
    occurred_at  TIMESTAMP NOT NULL,
    session_id   VARCHAR(100),
    properties   JSONB,                         -- 부가정보 (Phase 8에서 활용)
    CONSTRAINT fk_events_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 회원 8명 (다양한 가입일·채널)
INSERT INTO users (email, name, signup_date, channel, country) VALUES
('kim@test.com',  '김민준', '2024-01-05', 'organic',  'KR'),
('lee@test.com',  '이서연', '2024-01-08', 'paid',     'KR'),
('park@test.com', '박지후', '2024-01-15', 'referral', 'KR'),
('choi@test.com', '최유나', '2024-02-03', 'paid',     'KR'),
('jung@test.com', '정도윤', '2024-02-12', 'organic',  'US'),
('kang@test.com', '강하은', '2024-03-01', 'organic',  'KR'),
('yoon@test.com', '윤시우', '2024-03-09', 'paid',     'JP'),
('lim@test.com',  '임채원', '2024-03-20', 'referral', 'KR');

-- 상품 6개 (카테고리·가격·원가)
INSERT INTO products (name, category, price, cost) VALUES
('무선 이어폰',   'electronics', 89000,  45000),
('기계식 키보드', 'electronics', 120000, 70000),
('텀블러',        'lifestyle',   25000,  9000),
('백팩',          'fashion',     65000,  30000),
('데스크매트',    'lifestyle',   18000,  6000),
('USB 허브',      'electronics', 32000,  15000);

-- 주문 8건 (일부 취소/환불 포함)
INSERT INTO orders (user_id, order_date, status) VALUES
(1, '2024-01-10', 'completed'),
(1, '2024-02-15', 'completed'),
(2, '2024-01-20', 'completed'),
(3, '2024-01-25', 'cancelled'),
(4, '2024-02-10', 'completed'),
(5, '2024-02-20', 'refunded'),
(6, '2024-03-05', 'completed'),
(2, '2024-03-18', 'completed');

-- 주문 상세 (한 주문에 여러 상품 = N:M 연결)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 89000),
(1, 3, 2, 25000),
(2, 2, 1, 120000),
(3, 4, 1, 65000),
(4, 5, 1, 18000),
(4, 6, 2, 32000),
(5, 1, 1, 89000),
(6, 2, 1, 120000),
(7, 3, 3, 25000),
(8, 4, 1, 65000),
(8, 6, 1, 32000);

-- 행동 이벤트 (퍼널 분석용 샘플)
INSERT INTO events (user_id, event_name, occurred_at, session_id) VALUES
(1, 'page_view',    '2024-01-10 09:00:00', 's001'),
(1, 'add_to_cart',  '2024-01-10 09:05:00', 's001'),
(1, 'checkout',     '2024-01-10 09:08:00', 's001'),
(1, 'purchase',     '2024-01-10 09:10:00', 's001'),
(2, 'page_view',    '2024-01-20 14:00:00', 's002'),
(2, 'add_to_cart',  '2024-01-20 14:03:00', 's002'),
(3, 'page_view',    '2024-01-25 18:00:00', 's003'),
(3, 'add_to_cart',  '2024-01-25 18:02:00', 's003'),
(3, 'checkout',     '2024-01-25 18:05:00', 's003'),
(4, 'page_view',    '2024-02-10 11:00:00', 's004'),
(4, 'purchase',     '2024-02-10 11:15:00', 's004');