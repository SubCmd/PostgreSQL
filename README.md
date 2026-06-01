# How To Use PostgreSQL



## PostgreSQL 비밀번호 수정하는 방법?
### 비밀번호를 아는 경우?
```psql(powershell)
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "ALTER USER postgres WITH PASSWORD '새비밀번호';"
```

### 비밀번호를 모르는 경우?
1. 해당 경로로 들어간다.
C:\Program Files\PostgreSQL\18\data\pg_hba.conf

2. 해당 파일을 열고, 가장 아래에 IPv6 / IPv4 local 줄에서
local all all               scram-sha-256
host all all 127.0.0.1/21   scram-sha-256
host all all ::1/128        scram-sha-256

아래처럼 수정 (trust하면 보안상 위험)
local all all               trust
host all all 127.0.0.1/21   trust
host all all ::1/128        trust

이후에 아래 코드 실행
```powershell
Restart-Service postgresql-x64-18
```

3. 이후에 trust를 다시 scram-sha-256로 다시 변경해야함.

4. 접속 확인
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "SELECT version();"