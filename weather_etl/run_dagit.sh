#!/usr/bin/env bash
# Spouští Dagit-UI pro náš weather_etl projekt

export DAGSTER_HOME=$(pwd)/dagster_home
mkdir -p "$DAGSTER_HOME"

dagit -w dagster_project/workspace.yaml

