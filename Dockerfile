# ---- Stage 1: Builder ----
FROM python:3.12-slim AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential

COPY pyproject.toml .

RUN pip install --upgrade pip
RUN pip install .[test]

COPY src ./src
COPY tests ./tests

# ---- Stage 2: Runtime ----
FROM python:3.12-slim
WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY pyproject.toml .
COPY src ./src

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8055"]

