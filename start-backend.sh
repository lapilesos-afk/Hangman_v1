#!/bin/bash

# Hangman Game - Backend Quick Start Script
# This script sets up and runs the Spring Boot backend

set -e

echo "========================================"
echo "Hangman Game - Backend Setup"
echo "========================================"
echo ""

# Check Java installation
echo "Checking Java installation..."
if ! command -v java &> /dev/null; then
    echo "ERROR: Java is not installed. Please install Java 17 or higher."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | grep "version" | head -1)
echo "✓ Java found: $JAVA_VERSION"
echo ""

# Check Maven installation
echo "Checking Maven installation..."
if ! command -v mvn &> /dev/null; then
    echo "ERROR: Maven is not installed. Please install Maven 3.6 or higher."
    exit 1
fi

MVN_VERSION=$(mvn -version | head -1)
echo "✓ Maven found: $MVN_VERSION"
echo ""

# Navigate to backend directory
cd backend

echo "Building the project..."
echo "========================================"
mvn clean install
echo "========================================"
echo "✓ Build complete!"
echo ""

echo "Starting Spring Boot application..."
echo "========================================"
echo "Backend will be available at: http://localhost:8080"
echo "H2 Console: http://localhost:8080/h2-console"
echo ""
echo "Press Ctrl+C to stop the server"
echo "========================================"

mvn spring-boot:run
