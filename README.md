# pymock-example

[![Python Versions](https://img.shields.io/badge/python-3.8%20|%203.9%20|%203.10%20|%203.11-blue.svg)](#)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#)
![pymock-example](https://img.shields.io/badge/version-1.0.0-blue.svg)

-----

## 📖 Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
  - [Environment Variable Overrides](#environment-variable-overrides)
- [Quick Start](#quick-start)
  - [Local Development](#local-development)
  - [Docker Usage](#docker-usage)
- [Endpoints](#endpoints)
  - [Users Endpoint](#users-endpoint)
  - [Orders Endpoint](#orders-endpoint)
- [Templates](#templates)
- [Example Requests](#example-requests)
- [License](#license)
- [Contact](#contact)

---

## 🚀 Introduction

**pymock-example** is a demonstration project showcasing how to use [PyMock](https://github.com/qualitycoe/pymock) to create a **rule-based mock server**. It features:

- **Multiple endpoints** defined via YAML.
- **RuleEngineX-powered scenarios** for conditional responses.
- **Jinja2 templates** for dynamic rendering.
- **Simple Docker integration** to run the mock service in containers.
- **Environment variable overrides** for config flexibility.

This example helps you see PyMock in action and can serve as a template for your own mock-API needs.

---

## 🔥 Features

✔ **Easy Endpoint Definition**: All routes are specified in straightforward YAML files.  
✔ **Scenario Matching**: Each endpoint can have multiple scenarios, determined by powerful rule logic.  
✔ **Jinja2 Templates**: Dynamically render content, including HTML or JSON.  
✔ **Docker-Ready**: Quickly containerize your mock service for consistent deployments.  
✔ **Environment Overrides**: Adjust server settings without changing YAML files.  

---

## 🏗 Project Structure

```
pymock-example/
├── config.yaml
├── Dockerfile
├── endpoints/
│   ├── users.yaml
│   └── orders.yaml
├── templates/
│   ├── greeting.html
│   └── order_confirmation.html
├── Makefile
├── requirements.txt
├── README.md
└── main.py
```

- **`config.yaml`** – Main configuration for PyMock, defining server host/port and endpoint directories.  
- **`endpoints/`** – Contains YAML files that define API endpoints and scenarios.  
- **`templates/`** – Jinja2 templates for rendering HTML responses.  
- **`Dockerfile`** – Docker configuration for building and running the mock server container.  
- **`Makefile`** (optional) – Provides handy commands for local dev, install, run, etc.  
- **`requirements.txt`** – Lists dependencies, including PyMock.  
- **`main.py`** – Minimal Python script that starts PyMock using the specified `config.yaml`.  

---

## 📦 Installation

1. **Clone** this repository:
   ```bash
   git clone https://github.com/yourorg/pymock-example.git
   cd pymock-example
   ```
2. **Install** Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
   Make sure `pymock` is included in `requirements.txt` or installed in your environment.

---

## ⚙️ Configuration

The **`config.yaml`** provided here is a minimal example:

```yaml
server:
  host: "0.0.0.0"
  port: 8085

endpoints_path:
  - "endpoints/"
```

- **`server.host`** – Typically `0.0.0.0` in Docker, so the container is accessible externally.  
- **`server.port`** – The internal port the Flask server listens on (e.g., 8085).  
- **`endpoints_path`** – A list of directory paths where endpoint `.yaml` files reside.  

### Environment Variable Overrides
PyMock can override config fields with environment variables:

| Environment Variable              | Overrides                |
|----------------------------------|--------------------------|
| `PYMOCK__SERVER__HOST`           | `server.host`            |
| `PYMOCK__SERVER__PORT`           | `server.port`            |
| `PYMOCK__SERVER__ENDPOINTS_PATH` | `endpoints_path` (comma-separated) |

Example:

```bash
export PYMOCK__SERVER__HOST="0.0.0.0"
export PYMOCK__SERVER__PORT="8000"
pymock config.yaml
```

---

## 🚀 Quick Start

### 1️⃣ Local Development

1. **Install** dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. **Run** the mock server:
   ```bash
   python main.py
   ```
   or
   ```bash
   pymock config.yaml
   ```
3. You should see something like:
   ```
   * Running on http://0.0.0.0:8085
   ```
4. **Send requests** to `http://127.0.0.1:8085/users` or `http://127.0.0.1:8085/orders`, etc.

### 2️⃣ Docker Usage

1. **Build** the Docker image:
   ```bash
   docker build -t pymock-example .
   ```
2. **Run** the container, publishing port 8085:
   ```bash
   docker run --rm -p 8085:8085 \
      -e PYMOCK__SERVER__HOST="0.0.0.0" \
      -e PYMOCK__SERVER__PORT="8085" \
      pymock-example
   ```
3. PyMock will be accessible at `http://127.0.0.1:8085/`.

---

## 📜 Endpoints

Endpoints are declared in **YAML** under `endpoints/`. Each file can define **one or more** endpoints. 

### **Users Endpoint**

**`endpoints/users.yaml`**:

```yaml
path: "/users"
method: "GET"
scenarios:
  - scenario_name: "Admin Users"
    rules:
      - target: "params"        # or "query_params" if you customized RuleEngineX
        prop: "admin"
        op: "EQUALS"
        value: "true"
    response:
      status: 200
      data:
        msg: "List of admin users"
        users:
          - id: 1
            name: "Admin Alice"
          - id: 2
            name: "Admin Bob"

  - scenario_name: "Non-Admin"
    rules: []
    response:
      status: 200
      data:
        msg: "List of normal users"
        users:
          - id: 101
            name: "Charlie"
          - id: 102
            name: "Diana"
```

- If `?admin=true` is present, the first scenario matches.  
- Otherwise, it falls back to the second scenario.

### **Orders Endpoint**

**`endpoints/orders.yaml`**:

```yaml
path: "/orders"
method: "POST"
scenarios:
  - scenario_name: "Special Item Order"
    rules:
      - target: "body"
        prop: "$.items[*].id"
        op: "ARRAY_INCLUDES"
        value: 999
    response:
      status: 200
      template: "order_confirmation.html"
      data:
        message: "Order with special item included!"

  - scenario_name: "Generic Order"
    rules: []
    response:
      status: 200
      data:
        message: "Order received!"
```

- If the JSON body includes `items` with `id=999`, the first scenario returns a **Jinja2 template**.  
- Otherwise, the second scenario is used.

---

## 🎨 Templates

Located in **`templates/`**. For example:

### 1️⃣ `order_confirmation.html`
```html
<html>
  <head><title>Order Confirmation</title></head>
  <body>
    <h1>Order Confirmation</h1>
    <p>{{ message }}</p>

    <h2>Request Debug Info</h2>
    <p>Method: {{ request.method }}</p>
    <p>Path: {{ request.path }}</p>
  </body>
</html>
```

The `message` key in the scenario `data` merges into `{{ message }}`, and `request` is also accessible for advanced usage.

---

## 💥 Example Requests

After you’ve started PyMock:

1. **Get Admin Users**  
   ```bash
   curl "http://127.0.0.1:8085/users?admin=true"
   ```
   **Response**:
   ```json
   {
     "msg": "List of admin users",
     "users": [
       {"id": 1, "name": "Admin Alice"},
       {"id": 2, "name": "Admin Bob"}
     ]
   }
   ```

2. **Post an Order with Special Item**  
   ```bash
   curl -X POST http://127.0.0.1:8085/orders \
       -H "Content-Type: application/json" \
       -d '{"items":[{"id":999}]}'
   ```
   - You’ll see an HTML response (rendered from `order_confirmation.html`) with the message “Order with special item included!”

---

## 📖 License

pymock-example is distributed under the **MIT License**.  
Feel free to copy, adapt, and integrate this example into your own projects!

---

## 📬 Contact

For any issues or suggestions related to **pymock-example**, feel free to [open an issue](#) in your own fork or reach out to the maintainers of [PyMock](https://github.com/qualitycoe/pymock/issues). 

Happy mocking!