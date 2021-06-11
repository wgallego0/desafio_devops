#!/bin/bash
cd /app/
gunicorn -b 0.0.0.0:8000 api:app --daemon
