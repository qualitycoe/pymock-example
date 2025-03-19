FROM python:3.13

WORKDIR /app

COPY requirements.txt .
COPY config.yaml .
COPY endpoints/ endpoints/
COPY templates/ templates/
COPY main.py .

# Make sure pip is up-to-date (optional but often helpful)
RUN pip install --no-cache-dir --upgrade pip

# Force pip to re-fetch from Git, ignoring cached wheels
RUN pip install --no-cache-dir --upgrade --force-reinstall -r requirements.txt

# Create logs directory if you need it for logs
RUN mkdir /logs

EXPOSE 8085

CMD ["python", "main.py"]
