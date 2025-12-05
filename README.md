# README

This README documents the steps necessary to get the application up and running.

## Prerequisites

* Ruby version (see `.ruby-version`)
* Docker and Docker Compose
* PostgreSQL (via Docker Compose)

## Getting Started

### 1. Start PostgreSQL Database

Start the PostgreSQL database server using Docker Compose:

```bash
docker-compose up -d
```

This will start a PostgreSQL 16 container with the following default settings:
- Host: `localhost`
- Port: `5432`
- Database: `maco_api_development`
- Username: `postgres`
- Password: `postgres`

To stop the database:
```bash
docker-compose down
```

To stop and remove all data:
```bash
docker-compose down -v
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Database Setup

Create and migrate the database:

```bash
rails db:create
rails db:migrate
```

For the test environment:
```bash
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate
```

### 4. Environment Variables (Optional)

The application uses the following environment variables with defaults:

- `DATABASE_HOST` (default: `localhost`)
- `DATABASE_PORT` (default: `5432`)
- `DATABASE_USERNAME` (default: `postgres`)
- `DATABASE_PASSWORD` (default: `postgres`)
- `DATABASE_NAME` (default: `maco_api_development` for development, `maco_api_test` for test)

You can override these by setting them in your environment or using a `.env` file.

## Configuration

* Database: PostgreSQL (configured in `config/database.yml`)
* Services: Job queues, cache servers, search engines, etc.

## Database Initialization

After starting the PostgreSQL container, run:
```bash
rails db:create db:migrate
```

## How to Run the Test Suite

```bash
rspec
```

Make sure the test database is set up:
```bash
RAILS_ENV=test rails db:create db:migrate
```

## Deployment Instructions

For production deployment, ensure the following environment variables are set:
- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `DATABASE_NAME`
