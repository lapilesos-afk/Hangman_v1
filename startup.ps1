#!/usr/bin/env pwsh
# ============================================================================
# Hangman Game - Local Startup Script (PowerShell)
# Cross-platform compatible (Windows, macOS, Linux)
# ============================================================================

param(
    [switch]$SkipDependencyCheck = $false,
    [switch]$BuildOnly = $false,
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
$VerbosePreference = if ($Verbose) { "Continue" } else { "SilentlyContinue" }

# Configuration
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$BACKEND_DIR = Join-Path $SCRIPT_DIR "backend"
$FRONTEND_DIR = $SCRIPT_DIR
$LOG_DIR = Join-Path $SCRIPT_DIR "logs"
$BACKEND_PORT = 8080
$FRONTEND_PORT = 4200

# Colors
$SUCCESS = "Green"
$ERROR_COLOR = "Red"
$WARNING = "Yellow"
$INFO = "Cyan"

# ============================================================================
# Helper Functions
# ============================================================================

function Write-Status {
    param([string]$Message, [string]$Color = $INFO)
    Write-Host $Message -ForegroundColor $Color
}

function Check-Command {
    param([string]$Command)
    try {
        $output = & $Command --version 2>&1
        return $true, $output
    } catch {
        return $false, $null
    }
}

function Check-Port {
    param([int]$Port)
    try {
        $connection = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        return $connection -eq $null
    } catch {
        return $true
    }
}

function Ensure-Directory {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Verbose "Created directory: $Path"
    }
}

# ============================================================================
# Main Script
# ============================================================================

Clear-Host
Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "                                                                            " -ForegroundColor Cyan
Write-Host "  HANGMAN GAME - LOCAL STARTUP (NO DOCKER REQUIRED)                        " -ForegroundColor Cyan
Write-Host "                                                                            " -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""

# Create log directory
Ensure-Directory $LOG_DIR

# Check prerequisites
if (-not $SkipDependencyCheck) {
    Write-Status "[SETUP] Checking prerequisites..." -Color $INFO
    Write-Host ""

    # Check Java
    Write-Host "  [1] Checking Java..."
    $javaOk, $javaVersion = Check-Command "java"
    if (-not $javaOk) {
        Write-Status "      [ERROR] Java not found!" -Color $ERROR_COLOR
        Write-Host "      Please install Java 17+ from: https://www.oracle.com/java/technologies/"
        exit 1
    }
    Write-Status "      [OK] $($javaVersion -split "`n" | Select-Object -First 1)" -Color $SUCCESS

    # Check npm
    Write-Host "  [2] Checking Node.js/npm..."
    $npmOk, $npmVersion = Check-Command "npm"
    if (-not $npmOk) {
        Write-Status "      [ERROR] npm not found!" -Color $ERROR_COLOR
        Write-Host "      Please install Node.js from: https://nodejs.org/"
        exit 1
    }
    Write-Status "      [OK] npm $npmVersion" -Color $SUCCESS

    # Check Maven
    Write-Host "  [3] Checking Maven..."
    $mvnOk, $mvnVersion = Check-Command "mvn"
    if (-not $mvnOk) {
        Write-Status "      [ERROR] Maven not found!" -Color $ERROR_COLOR
        Write-Host "      Please install Maven from: https://maven.apache.org/download.cgi"
        exit 1
    }
    $mvnVersionLine = $mvnVersion -split "`n" | Where-Object { $_ -match "Apache Maven" } | Select-Object -First 1
    Write-Status "      [OK] $mvnVersionLine" -Color $SUCCESS

    # Check ports
    Write-Host "  [4] Checking ports..."
    $backendPortFree = Check-Port $BACKEND_PORT
    if ($backendPortFree) {
        Write-Status "      [OK] Port $BACKEND_PORT available" -Color $SUCCESS
    } else {
        Write-Status "      [WARNING] Port $BACKEND_PORT already in use" -Color $WARNING
    }

    $frontendPortFree = Check-Port $FRONTEND_PORT
    if ($frontendPortFree) {
        Write-Status "      [OK] Port $FRONTEND_PORT available" -Color $SUCCESS
    } else {
        Write-Status "      [WARNING] Port $FRONTEND_PORT already in use" -Color $WARNING
    }

    Write-Host ""
}

# Build Backend
Write-Status "[BUILD] Building application..." -Color $INFO
Write-Host ""

Write-Host "  [1] Building Backend (Spring Boot)..."
Push-Location $BACKEND_DIR
try {
    & mvn clean package -DskipTests -q 2> (Join-Path $LOG_DIR "backend-build.log")
    if ($LASTEXITCODE -ne 0) {
        Write-Status "      [ERROR] Backend build failed!" -Color $ERROR_COLOR
        Write-Host "      Check logs at: $(Join-Path $LOG_DIR 'backend-build.log')"
        exit 1
    }
    Write-Status "      [OK] Backend built successfully" -Color $SUCCESS
} finally {
    Pop-Location
}

# Check frontend dependencies
Write-Host "  [2] Checking Frontend dependencies..."
Push-Location $FRONTEND_DIR
try {
    if (-not (Test-Path "node_modules")) {
        Write-Host "      Installing npm packages..."
        & npm install -q 2> (Join-Path $LOG_DIR "npm-install.log")
        if ($LASTEXITCODE -ne 0) {
            Write-Status "      [WARNING] npm install had issues. Continuing anyway..." -Color $WARNING
        }
    }
    Write-Status "      [OK] Frontend ready" -Color $SUCCESS
} finally {
    Pop-Location
}

Write-Host ""

# If build only flag is set, exit here
if ($BuildOnly) {
    Write-Status "[OK] Build completed successfully!" -Color $SUCCESS
    exit 0
}

# Launch services
Write-Status "[STARTUP] Starting services..." -Color $INFO
Write-Host ""

# Launch Backend
Write-Host "  [1] Launching Backend on port $BACKEND_PORT..."
$backendLog = Join-Path $LOG_DIR "backend.log"
$backendProcess = Start-Process -FilePath "powershell" -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$BACKEND_DIR'; mvn spring-boot:run *> '$backendLog'"
) -PassThru

Write-Status "      [OK] Backend starting..." -Color $SUCCESS

# Wait for backend to initialize
Write-Host "  [*] Waiting for backend to initialize (15 seconds)..."
Start-Sleep -Seconds 15

# Launch Frontend
Write-Host "  [2] Launching Frontend on port $FRONTEND_PORT..."
$frontendLog = Join-Path $LOG_DIR "frontend.log"
$frontendProcess = Start-Process -FilePath "powershell" -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$FRONTEND_DIR'; .\node_modules\.bin\ng serve *> '$frontendLog'"
) -PassThru

Write-Status "      [OK] Frontend starting..." -Color $SUCCESS

# Wait for frontend to compile
Start-Sleep -Seconds 10

# Final message
Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Status "  SUCCESS! Your Hangman Game is running!" -Color $SUCCESS
Write-Host ""
Write-Host "  Frontend:   http://localhost:$FRONTEND_PORT"
Write-Host "  Backend:    http://localhost:$BACKEND_PORT"
Write-Host ""
Write-Host "  Logs are saved in: $LOG_DIR"
Write-Host "  - backend.log    (Spring Boot output)"
Write-Host "  - frontend.log   (Angular output)"
Write-Host ""
Write-Host "  To stop the application, close the PowerShell windows or press Ctrl+C"
Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""

# Wait for user input
Read-Host "Press Enter to exit this window"
