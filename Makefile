DB_URL=postgresql://postgres:postgres@localhost:5435/bank?sslmode=disable

createdb:
	docker exec -it db createdb if--username=postgres --owner=postgres bank

migrateup:
	migrate -path migrations -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path migrations -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path migrations -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path migrations -database "$(DB_URL)" -verbose down 1

test:
	go test -v -cover -short ./...