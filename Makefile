SHELL := /usr/bin/env bash

.PHONY: install run

install:
    pip install -r requirements.txt

run:
    python main.py
