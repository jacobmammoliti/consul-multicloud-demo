#!/bin/sh
set -e

gunicorn --bind :3000 --workers 1 main:app