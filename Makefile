.PHONY: help build test deploy clean docker-build docker-run docker-stop

# Default target
help:
	@echo "🚀 Job Dashboard CI/CD Commands:"
	@echo ""
	@echo "📦 Build & Test:"
	@echo "  build     - Generate fresh job data and HTML"
	@echo "  test      - Run validation tests"
	@echo "  clean     - Clean generated files"
	@echo ""
	@echo "🐳 Docker Commands:"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-run   - Run with Docker Compose"
	@echo "  docker-stop  - Stop Docker services"
	@echo ""
	@echo "🚀 Deployment:"
	@echo "  deploy    - Full deployment pipeline"
	@echo "  validate  - Validate HTML output"

# Build the project
build:
	@echo "🔨 Building project..."
	python render_data.py
	@echo "✅ Build completed!"

# Run tests
test:
	@echo "🧪 Running tests..."
	@if [ ! -s index.html ]; then \
		echo "❌ HTML file is empty or missing"; \
		exit 1; \
	fi
	@if ! grep -q 'id="total-jobs">[0-9]' index.html; then \
		echo "❌ Total jobs not found in HTML"; \
		exit 1; \
	fi
	@if ! grep -q 'id="us-jobs">[0-9]' index.html; then \
		echo "❌ US jobs not found in HTML"; \
		exit 1; \
	fi
	@if ! grep -q 'id="remote-jobs">[0-9]' index.html; then \
		echo "❌ Remote jobs not found in HTML"; \
		exit 1; \
	fi
	@echo "✅ All tests passed!"

# Validate HTML output
validate:
	@echo "🔍 Validating HTML output..."
	@python -c "
import re
with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()
    total_jobs = re.search(r'id=\"total-jobs\">(\d+)<', content)
    us_jobs = re.search(r'id=\"us-jobs\">(\d+)<', content)
    remote_jobs = re.search(r'id=\"remote-jobs\">(\d+)<', content)
    
    if total_jobs and us_jobs and remote_jobs:
        print(f'✅ Validation passed:')
        print(f'   Total jobs: {total_jobs.group(1)}')
        print(f'   US jobs: {us_jobs.group(1)}')
        print(f'   Remote jobs: {remote_jobs.group(1)}')
    else:
        print('❌ Validation failed')
        exit(1)
	"

# Clean generated files
clean:
	@echo "🧹 Cleaning project..."
	@rm -f *.log
	@echo "✅ Clean completed!"

# Docker commands
docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t job-dashboard .
	@echo "✅ Docker image built!"

docker-run:
	@echo "🚀 Starting Docker services..."
	docker-compose up -d
	@echo "✅ Services started! Access at http://localhost:8080"

docker-stop:
	@echo "🛑 Stopping Docker services..."
	docker-compose down
	@echo "✅ Services stopped!"

# Full deployment pipeline
deploy: build test validate
	@echo "🚀 Deployment pipeline completed successfully!"

# CI/CD pipeline simulation
ci-simulate:
	@echo "🔄 Simulating CI/CD pipeline..."
	@make clean
	@make build
	@make test
	@make validate
	@echo "🎉 CI/CD simulation completed successfully!"
