# # Part 1: SQL 환경 설정 & RDBMS 기초
: DB Beaver 이용해서 postgreSQL 이용해서 학습

## 1-1 RDBMS란?
RDBMS(Relational Database Management System, 관계형 데이터베이스 관리 시스템)
데이터를 표(table) 형태로 저장하고, 표 사이의 관계(relationship)를 통해 데이터를 연결하고 관리하는 시스템

> 💡 PM 관점
> 우리가 매일 보는 GA4, Amplitude의 원천 데이터도 결국 이런 테이블 구조
> SQL은 "이 표들에서 원하는 숫자를 뽑아내는 언어"

- 대표적 RDBMS
PostgreSQL, MySQL, Oracle, SQL Server, SQLite


## 1-2. 관계형 모델의 3요소

| 모델 용어 | 일상 용어 | 설명 |
|----------|----------|------|
| 릴레이션(Relation) | 테이블(Table) | 데이터를 담는 표. 예: `users` |
| 튜플(Tuple) | 행(Row)/레코드 | 한 건의 데이터. 예: 회원 1명 | 
| 속성(Attribute) | 열(Column) / 필드 | 데이터의 항목. 예: `email`, `signup_date` |

```
users 테이블
┌──────────┬─────────────────┬─────────────┐
│ user_id  │ email           │ signup_date │  ← 열(Column / 속성)
├──────────┼─────────────────┼─────────────┤
│ 1        │ kim@test.com    │ 2024-01-05  │  ← 행(Row / 튜플)
│ 2        │ lee@test.com    │ 2024-01-08  │
└──────────┴─────────────────┴─────────────┘
```


## 1-3. 키(Key) - 데이터를 식별하고 연결하는 핵심

| 키 종류 | 정의 | 예시 | 
|--------|------|------|
| **기본키 (PK, Primary Key)** | 각 행을 **유일하게 식별**하는 열. 중복·NULL 불가 | `users.user_id` |
| **외래키 (FK, Foreign Key)** | 다른 테이블의 PK를 참조해 **관계를 맺는** 열 | `orders.user_id` → `users.user_id` |
| 후보키 (Candidate Key) | PK가 될 수 있는 후보들 | `user_id`, `email` |
| 대체키 (Alternate Key) | 후보키 중 PK로 선택되지 않은 것 | `email` |
| 복합키 (Composite Key) | 여러 열을 묶어 PK로 사용 | (`order_id`, `product_id`) |

> 💡 SQLD 포인트
> SQLD 1과목에서 "주식별자/보조식별자", "단일식별자/복합식별자"
> PK = 주식별자, 여러 열로 구성되면 복합식별자


## 1-4. 관계(Relationship)의 종류

| 관계 | 의미 | 이커머스 예시 |
|------|------|-------------|
| **1:1** | 한 건이 한 건과 대응 | 회원 1명 ↔ 회원상세정보 1건 |
| **1:N** | 한 건이 여러 건과 대응 | 회원 1명 → 주문 여러 건 |
| **N:M** | 여러 건이 여러 건과 대응 | 주문 ↔ 상품 (한 주문에 여러 상품, 한 상품은 여러 주문에) |

> ⚠️ N:M은 직접 표현할 수 없다.
> 중간에 연결 테이블(junction table)을 둔다.
> 우리 스키마에서는 `order_items`가 `orders`와 `products`의 N:M을 풀어주는 연결 테이블


## 1-5. SQLD 모델링 핵심 용어
- **엔터티(Entity)**: 관리해야 할 대상 → 테이블이 됨 (회원, 상품, 주문)
- **속성(Attribute)**: 엔터티의 특징 → 열이 됨 (이름, 가격)
- **관계(Relationship)**: 엔터티 간 연관 → FK로 구현
- **식별자(Identifier)**: 엔터티를 구분하는 기준 → PK로 구현


------------------------------------------------------------------------------------------------------------
## 4. 연습문제
Q1. 다음 용어를 RDBMS 용어로 바꿔 쓰시오.
(1) 표 (2) 한 건의 데이터 (3) 데이터 항목

(1) Table / Relation
(2) Tuple / Row / Record 
(3) Attribute / Column / Field


Q2. `users` 테이블의 구조(컬럼·타입·키)를 확인하는 psql 명령어를 쓰시오.

\d users
전체 테이블 목록 : \dt
전체 DB 목록 : \l


Q3. 기본키(PK)와 외래키(FK)의 차이를 한 문장씩으로 설명하시오.
PK : 한 테이블 안에서 각 행을 유일하게 식별하는 열 (중복 / NULL 불가)
FK : 다른 테이블의 PK를 참조해 테이블 간 관계를 맺는 열

예) `orders.user_id(FK)`, `users.user_id(PK)`를 참조
