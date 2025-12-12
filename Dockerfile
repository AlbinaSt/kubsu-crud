# Stage 1: Test

FROM python:3.11-slim AS test

WORKDIR /app

COPY pyproject.toml .
COPY src/ ./src
COPY tests/ ./tests
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -e .[test]

# Stage 2: Runtime

FROM python:3.11-slim AS runtime


WORKDIR /app
COPY --from=test /app /app
EXPOSE 8055

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8055"]
