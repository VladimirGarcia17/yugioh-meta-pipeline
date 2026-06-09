# yugioh-meta-pipeline

An end-to-end ELT data engineering pipeline for Yu-Gi-Oh! card data, built on the YGOPRODeck API.

## Overview

Extracts the full card catalog from the YGOPRODeck API, lands it raw in PostgreSQL,
and transforms it with dbt into a star schema for meta and banlist analysis.

## Stack

- **Python** — extraction (API → raw)
- **PostgreSQL** — data warehouse
- **dbt** — transformations (staging → intermediate → marts)
- **Docker** — containerized environment
- **Airflow** — orchestration *(in progress)*
- **Power BI** — visualization *(planned)*

## Architecture

Raw JSON is loaded into PostgreSQL, then modeled through three dbt layers
into a star schema (one card dimension, two historical fact tables for
banlist status and prices, snapshotted by date).

## Status

Work in progress — building incrementally as a portfolio project.

## Setup

_Detailed setup instructions coming soon._