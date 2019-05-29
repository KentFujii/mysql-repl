# mysql-repl

docker環境でmysqlのmaster/slave構成を試すリポジトリです

下記のコマンドでレプリケーションがうまく実行されているかを確認します

## テストコマンド

既存のdatabaseにtableを追加する

```
docker-compose exec mysql-master bash -c "mysql -u root --password=root test -e 'create table buildings ( id INT not null );'"
docker-copmose exec mysql-slave bash -c "mysql -u root --password=root test -e 'show tables;'"
```

新しくdatabaseを追加する

```
docker-compose exec mysql-master bash -c "mysql -u root --password=root -e 'create database sample;'"
docker-compose exec mysql-slave bash -c "mysql -u root --password=root -e 'show databases;'"
```
