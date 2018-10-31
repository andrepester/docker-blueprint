#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo "[Docker DB] data directory already created"
else
	echo "[Docker DB] create data directory"

	chown -R mysql:mysql /var/lib/mysql

	echo "[Docker DB] init DB"

	mysql_install_db --user=mysql > /dev/null

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
EOF

	echo "[Docker DB] execute mysql with: $tfile"

	/usr/bin/mysqld --user=mysql --bootstrap < $tfile

	rm -f $tfile
fi

echo "[Docker DB] start process"
exec /usr/bin/mysqld --user=mysql --console