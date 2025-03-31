FROM postgres:14.2

COPY /deployments/postgres/conf/postgresql.conf /etc/postgresql/postgresql.conf
COPY /deployments/postgres/conf/pg_hba.conf /etc/postgresql/pg_hba.conf

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]