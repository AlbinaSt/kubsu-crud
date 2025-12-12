# Stage 1: test
FROM python:3.11-slim AS test
WORKDIR /app
COPY pyproject.toml .
COPY src/ ./src
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -e .[test]

# Stage 2: runtime
FROM python:3.11-slim AS runtime
WORKDIR /app
COPY --from=test /app /app
EXPOSE 8064
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8064"]
