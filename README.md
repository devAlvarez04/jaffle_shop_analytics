# Jaffle Shop Analytics

Analytics engineering project built with dbt Core and DuckDB, using the
Jaffle Shop dataset from dbt Labs.

## Stack

- dbt Core 1.12 + dbt-duckdb
- DuckDB (local file database)

## Getting started (Windows / PowerShell)

    . .\setup.ps1
    python scripts/load_raw.py
    dbt debug
    dbt source freshness
    dbt build
