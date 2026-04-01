# 300150295 - TP PL/pgSQL

## Lancer PostgreSQL
docker run -d --name tp_postgres -e POSTGRES_USER=etudiant -e POSTGRES_PASSWORD=etudiant -e POSTGRES_DB=tpdb -p 5432:5432 postgres:15

## Se connecter
docker exec -it tp_postgres psql -U etudiant -d tpdb

## Lancer les tests
docker exec -i tp_postgres psql -U etudiant -d tpdb -f /tests/test.sql
