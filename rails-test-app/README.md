# Clean Rails Test App for Crash Reproduction

## 🎯 Purpose

This is a clean, minimal Rails 8.0.2 application specifically designed to reproduce the ActionController::Live segmentation fault described in issue #55132.

## 🏗️ Structure

```
rails-test-app/
├── app/
│   └── controllers/
│       └── test_controller.rb      # Controller that triggers the crash
├── config/
│   ├── application.rb              # Main Rails configuration
│   ├── boot.rb                     # Boot configuration
│   ├── database.yml                # Database configuration
│   ├── environments/
│   │   └── development.rb          # Development environment
│   └── routes.rb                   # Routes configuration
├── Gemfile                         # Dependencies
└── crash_test.rb                   # Simple crash test script
```

## 🚀 Quick Start

### 1. Install Dependencies
```bash
bundle install
```

### 2. Run the Crash Test
```bash
ruby crash_test.rb
```

### 3. Start the Rails Server
```bash
rails server -p 3000
```

### 4. Test the Endpoint
```bash
curl http://localhost:3000/test
```

## 🧪 Crash Test Controller

The `TestController` includes `ActionController::Live` and creates multiple PostgreSQL connections with concurrent access patterns designed to trigger the "double concurrent PG#close" crash.

## 🔍 What to Look For

- **Segmentation faults**: Check for core dumps in `/tmp/core_dumps/`
- **Race conditions**: Multiple threads accessing the same connection
- **Double close attempts**: Multiple threads calling PG#close simultaneously

## ⚠️ Safety Notes

- This app is designed to crash - use only in isolated environments
- Monitor system resources during testing
- Check for core dumps after each test run

## 🐳 Docker Usage

This app is designed to work with the Docker environment in the parent directory. The Docker setup will:

1. Build the Rails app
2. Connect to PostgreSQL
3. Enable core dumps
4. Mount the app for live development

## 📊 Expected Behavior

- **If successful**: Race conditions created, potential crashes
- **If crash occurs**: Segmentation fault with core dump
- **If no crash**: Race conditions documented for further investigation

Docker commands
```
# From the docker directory
docker-compose -f docker-compose.crash-reproduction.yml up -d --build

# Get into the container shell
docker exec -it docker-rails-crash-test-1 bash

# Inside the container
cd /app

# Run the precision crash test
ruby precision_crash_test.rb

# Or run the enhanced crash test
ruby enhanced_crash_test.rb

# Or run the simple crash test
ruby simple_crash_test.rb

# See if containers are running
docker-compose -f docker-compose.crash-reproduction.yml ps

# View logs
docker-compose -f docker-compose.crash-repose.yml logs

# Build and start
docker-compose -f docker-compose.crash-reproduction.yml up -d --build

# Get into container
docker exec -it docker-rails-crash-test-1 bash

# Run test
cd /app && ruby precision_crash_test.rb
```