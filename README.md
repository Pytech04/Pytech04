# Wayback URL Pattern Checker

## Overview

Welcome to the **Wayback URL Pattern Checker**! This tool is designed for cybersecurity enthusiasts, penetration testers, and researchers to analyze URLs archived in the Wayback Machine. It helps you identify URLs that match specific patterns and return critical HTTP status codes (`200 OK` or `403 Forbidden`).

## Features

- **Pattern Matching**: Identify URLs from Wayback Machine snapshots that match specified patterns.
- **Status Code Filtering**: Focus on URLs that return `200 OK` or `403 Forbidden`.
- **Real-Time Output**: View results as they are processed.

## Getting Started

### Prerequisites

1. **Waybackurls**: Install `waybackurls` if you haven't already. You can install it with:
   ```bash
   go install github.com/tomnomnom/waybackurls@latest
