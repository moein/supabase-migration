#!/usr/bin/env bash

SUPABASE_PORT=${SUPABASE_PORT-5432}
SUPABASE_USER=${SUPABASE_USER-postgres}
SUPABASE_DB=${SUPABASE_DB-postgres}

rm -rf migrations_replaced
cp -R migrations migrations_replaced

perl -i -pe "s~WEBHOOK_URL~${WEBHOOK_URL}~g" ./migrations_replaced/*
perl -i -pe "s~WEBHOOK_SECRET~${WEBHOOK_SECRET}~g" ./migrations_replaced/*

pg-migrate "$@" --migrations-dir=migrations_replaced --db=${SUPABASE_DB} --host="${SUPABASE_HOST}" --port="${SUPABASE_PORT}" --user="${SUPABASE_USER}" --password="${SUPABASE_PASSWORD}"
rm -rf migrations_replaced