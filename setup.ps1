# setup.ps1 - prepares the local development environment
$ErrorActionPreference = "Stop"

# 1. Check that Python 3.13 is available
py -V:3.13 --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Python 3.13 not found. Install it with: py install 3.13"
    exit 1
}

# 2. Create the virtual environment if needed
if (-not (Test-Path ".venv")) {
    Write-Host "Creating virtual environment..."
    py -V:3.13 -m venv .venv
} else {
    Write-Host "Virtual environment already exists."
}

# 3. Activate it
. .\.venv\Scripts\Activate.ps1

# 4. Install dependencies
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

# 5. Check dbt
dbt --version
Write-Host "Environment ready." -ForegroundColor Green