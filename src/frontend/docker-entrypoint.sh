#!/bin/sh
set -e

gunicorn --bind :8000 --workers 1 main:app