# Multi-stage Dockerfile for ThemeFinder development and production
# Supports both UV and Poetry package managers

FROM python:3.11-slim-bullseye as base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /app
RUN chown appuser:appuser /app

# Development stage with UV
FROM base as development-uv

# Copy dependency files
COPY --chown=appuser:appuser pyproject.uv.toml /app/pyproject.toml
COPY --chown=appuser:appuser uv.lock* /app/

USER appuser

# Install dependencies
RUN uv sync --dev

# Copy source code
COPY --chown=appuser:appuser . /app/

EXPOSE 8000 8888

CMD ["uv", "run", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# Development stage with Poetry  
FROM base as development-poetry

# Install Poetry
RUN pip install poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VENV_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Copy dependency files
COPY --chown=appuser:appuser pyproject.toml poetry.lock* /app/

USER appuser

# Install dependencies
RUN poetry install --with dev && rm -rf $POETRY_CACHE_DIR

# Copy source code
COPY --chown=appuser:appuser . /app/

EXPOSE 8000 8888

CMD ["poetry", "run", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# Production stage with UV
FROM base as production

# Copy dependency files
COPY pyproject.uv.toml /app/pyproject.toml
COPY uv.lock* /app/

# Install dependencies (production only)
RUN uv sync --no-dev

# Copy source code
COPY --chown=appuser:appuser src/ /app/src/
COPY --chown=appuser:appuser README.md LICENSE /app/

USER appuser

# Install the package
RUN uv pip install -e .

EXPOSE 8000

CMD ["python", "-m", "themefinder"]
