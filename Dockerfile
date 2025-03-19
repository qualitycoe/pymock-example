FROM python:3.13

WORKDIR /app

# Copy local files
COPY config.yaml ./
COPY endpoints/ endpoints/
COPY templates/ templates/
COPY requirements.txt requirements.txt
COPY main.py main.py

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 5000

# Run the mock server on container start
CMD ["python", "main.py"]
