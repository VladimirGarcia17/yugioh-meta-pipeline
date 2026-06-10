from datetime import datetime
from airflow.sdk import dag, task
from airflow.providers.standard.operators.bash import BashOperator

DB_ENV = (
    "POSTGRES_HOST=yugioh_postgres "
    "POSTGRES_PORT=5432 "
    "POSTGRES_DB=yugioh_db "
    "POSTGRES_USER=yugioh "
    "POSTGRES_PASSWORD=yugioh_dev_pwd"
)

@dag(
    dag_id="yugioh_pipeline",
    description="ELT pipeline for Yu-Gi-Oh! card data",
    schedule="@daily",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["yugioh", "elt"],
)
def yugioh_pipeline():

    extract = BashOperator(
        task_id="extract_cards",
        bash_command=(
            f"{DB_ENV} python /opt/airflow/extraction/extract.py"
        ),
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=(
            "cd /opt/airflow/dbt && "
            f"{DB_ENV} dbt run "
            "--profiles-dir /opt/airflow/dbt --target airflow"
        ),
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=(
            "cd /opt/airflow/dbt && "
            f"{DB_ENV} dbt test "
            "--profiles-dir /opt/airflow/dbt --target airflow"
        ),
    )

    extract >> dbt_run >> dbt_test

yugioh_pipeline()