# Use Python 3.9 slim image for smaller size
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install dependencies (currently none, but keeping for future)
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY render_data.py .
COPY index.html .

# Create a non-root user for security
RUN useradd --create-home --shell /bin/bash app && \
    chown -R app:app /app
USER app

# Expose port for web server (if needed)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import os; exit(0 if os.path.exists('index.html') else 1)"

# Default command
CMD ["python", "render_data.py"]
