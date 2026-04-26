# Use a stable Python version
FROM python:3.12-slim

# Install system dependencies for Data Science libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install 'uv' for extremely fast package management
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/bin/

# Set working directory
WORKDIR /app

# Create a non-root user for security
RUN useradd -m ds_user
RUN chown -R ds_user:ds_user /app
USER ds_user

# Pre-install core Data Science stack to save time
RUN uv pip install --system \
    jupyterlab \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    duckdb \
    lancedb \
    pyarrow

# Expose Jupyter port
EXPOSE 8888

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
