# Job Dashboard CI/CD Test Project

This is a simple project for testing CI/CD pipelines. It consists of an HTML dashboard and a Python script that renders data to it.

## Files

- **`index.html`** - A responsive job dashboard template with modern styling
- **`render_data.py`** - Python script that generates sample job data and renders it to HTML
- **`requirements.txt`** - Python dependencies (currently empty as we only use standard library)
- **`README.md`** - This file

## How to Use

### 1. Run the Python Script

```bash
python render_data.py
```

This will:
- Generate 25 sample job listings
- Update the HTML file with real data
- Display statistics (total jobs, US jobs, remote jobs)
- Update the timestamp

### 2. View the Dashboard

Open `index.html` in your web browser to see the populated dashboard.

### 3. For CI/CD Testing

You can use this in your CI/CD pipeline to:
- Test Python script execution
- Verify HTML file generation
- Check data rendering functionality
- Validate file output

## Sample Output

The script generates realistic job data including:
- Job titles (Software Engineer, Data Scientist, etc.)
- Company names
- Locations (US cities + Remote options)
- Salary ranges
- Posted dates

## Customization

- Modify `generate_sample_jobs()` in `render_data.py` to change the data structure
- Update the HTML template in `index.html` to change the dashboard layout
- Add more statistics or job details as needed

## Requirements

- Python 3.6+
- No external packages required (uses only standard library)
- Works on Windows, macOS, and Linux

## 🚀 CI/CD Integration

This project includes comprehensive CI/CD configurations for multiple platforms:

### GitHub Actions
- **File**: `.github/workflows/ci.yml`
- **Features**: Automated testing, validation, and deployment to GitHub Pages
- **Triggers**: Push to main/develop, PRs, daily scheduled runs
- **Actions**: Test → Validate → Deploy → Archive

### Docker & Docker Compose
- **Files**: `Dockerfile`, `docker-compose.yml`, `nginx.conf`
- **Features**: Containerized deployment with nginx web server
- **Ports**: Dashboard on port 8080, health checks included
- **Commands**: `make docker-build`, `make docker-run`, `make docker-stop`

### Jenkins Pipeline
- **File**: `Jenkinsfile`
- **Features**: Multi-stage CI/CD pipeline with Docker integration
- **Stages**: Checkout → Setup → Build → Test → Docker Build → Deploy → Archive
- **Cross-platform**: Supports both Unix and Windows environments

### Makefile Commands
```bash
make help          # Show all available commands
make build         # Generate fresh data and HTML
make test          # Run validation tests
make validate      # Validate HTML output
make deploy        # Full deployment pipeline
make ci-simulate   # Simulate complete CI/CD pipeline
make docker-build  # Build Docker image
make docker-run    # Start Docker services
make docker-stop   # Stop Docker services
```

### Quick Start for CI/CD Testing

1. **Local Testing**:
   ```bash
   make ci-simulate
   ```

2. **Docker Testing**:
   ```bash
   make docker-build
   make docker-run
   # Access at http://localhost:8080
   ```

3. **GitHub Actions**: Push to main branch to trigger automated pipeline

4. **Jenkins**: Import Jenkinsfile into your Jenkins instance

### CI/CD Pipeline Features

- ✅ **Automated Testing**: HTML validation, content checks
- ✅ **Docker Integration**: Containerized deployment
- ✅ **Cross-Platform**: Works on Windows, macOS, and Linux
- ✅ **Health Checks**: Built-in monitoring and validation
- ✅ **Artifact Archiving**: Preserves generated files
- ✅ **Scheduled Updates**: Daily data refresh automation
- ✅ **Multi-Environment**: Dev, staging, and production support
