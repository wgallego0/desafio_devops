#!/bin/bash
cd /var/www/html/desafio_devops/app/
gunicorn -b 0.0.0.0:8000 api:app --daemon
