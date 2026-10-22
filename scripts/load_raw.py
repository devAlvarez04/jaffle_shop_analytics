"""Load the raw Jaffle Shop CSV files into the `raw` schema of a DuckDB database.

This script plays the role of an ingestion tool (Fivetran, Airbyte...).
Data is loaded as text, as delivered: typing is the job of the dbt staging layer.
dbt itself never writes to the `raw` schema.
"""

import argparse
from pathlib import Path

import duckdb

RAW_DIR = Path("data/raw")

# raw table name -> CSV file name
TABLES = {
    "customers": "raw_customers.csv",
    "orders": "raw_orders.csv",
    "payments": "raw_payments.csv",
}


def load(db_path: str) -> None:
    con = duckdb.connect(db_path)
    con.sql("create schema if not exists raw")

    for table, file_name in TABLES.items():
        csv_path = (RAW_DIR / file_name).as_posix()
        con.sql(f"""
            create or replace table raw.{table} as
            select
                *,
                current_timestamp as _loaded_at
            from read_csv('{csv_path}', header = true, all_varchar = true)
        """)
        row_count = con.sql(f"select count(*) from raw.{table}").fetchone()[0]
        print(f"raw.{table}: {row_count} rows loaded")

    con.close()


def main() -> None:
    parser = argparse.ArgumentParser(description="Load raw Jaffle Shop data into DuckDB.")
    parser.add_argument(
        "--db",
        default="jaffle_shop.duckdb",
        help="Path to the DuckDB database file (default: jaffle_shop.duckdb)",
    )
    args = parser.parse_args()
    load(args.db)


if __name__ == "__main__":
    main()