# 🚀 FloNeo LCNC Platform - Collaborator Setup Guide

## 📋 Overview
FloNeo is a Low-Code No-Code (LCNC) platform built with Next.js frontend, Node.js/Express backend, PostgreSQL database, and Docker containerization. This guide will help you set up the project on your local system.

## 🛠️ Prerequisites
Before starting, ensure you have the following installed:
- **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **Git** - [Download here](https://git-scm.com/)
- **Code Editor** (VS Code recommended) - [Download here](https://code.visualstudio.com/)

## 📥 Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/fathima-cto/FloNeo.git

# Navigate to the project directory
cd FloNeo
```

## 📦 Step 2: Install Dependencies

### Backend Dependencies
```bash
# Navigate to server directory
cd server

# Install backend dependencies
npm install

# Generate Prisma client
npx prisma generate
```

### Frontend Dependencies
```bash
# Navigate to client directory (from project root)
cd client

# Install frontend dependencies
npm install
```

## 🔧 Step 3: Environment Configuration

### Backend Environment (.env)
Create or verify the `server/.env` file with the following configuration:

```env
# Database Configuration
DATABASE_URL="postgresql://floneo:floneo123@localhost:5432/floneo_db?schema=public"

# JWT Configuration
JWT_SECRET="floneo-super-secure-jwt-secret-key-2024-lcnc-platform"
JWT_REFRESH_SECRET="floneo-refresh-token-secret-key-2024-lcnc-platform"
JWT_EXPIRES_IN="15m"
JWT_REFRESH_EXPIRES_IN="7d"

# Email Configuration (Development Mode)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="587"
SMTP_SECURE="false"
SMTP_USER="development@floneo.com"
SMTP_PASS="development-mode-disabled"
EMAIL_FROM="FloNeo Platform <development@floneo.com>"
EMAIL_VERIFICATION_DISABLED="true"

# Application Configuration
NODE_ENV="development"
PORT="5000"
BCRYPT_SALT_ROUNDS="12"
```

### Frontend Environment (.env.local)
Create `client/.env.local` file:

```env
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:5000
NEXTAUTH_SECRET=floneo-nextauth-secret-key-2024
NEXTAUTH_URL=http://localhost:3000
```

## 🗄️ Step 4: Database Setup

### Using Docker (Recommended)
The project includes a complete Docker setup with PostgreSQL:

```bash
# From project root directory
docker-compose up -d postgres

# Wait for PostgreSQL to start (about 30 seconds)
# Then run database migrations
cd server
npx prisma migrate deploy

# Seed the database with initial data
npx prisma db seed
```

### Manual PostgreSQL Setup (Alternative)
If you prefer manual setup:

1. Install PostgreSQL locally
2. Create database: `floneo_db`
3. Create user: `floneo` with password: `floneo123`
4. Grant permissions to the user
5. Run migrations: `npx prisma migrate deploy`
6. Seed database: `npx prisma db seed`

## 🏗️ Step 5: Database Structure

The database includes the following main tables:

### Core Tables
- **User** - User accounts and authentication
- **App** - LCNC applications created by users
- **Template** - Pre-built app templates
- **Component** - App components and widgets
- **Workflow** - App workflow definitions

### Canvas System (Drag & Drop Editor)
- **Canvas** - Canvas configurations for each app
- **CanvasElement** - Individual elements on canvas (buttons, forms, etc.)
- **ElementInteraction** - Element event handlers
- **ElementValidation** - Form validation rules
- **CanvasHistory** - Canvas change history for undo/redo

### Supporting Tables
- **AppSchema/AppField/AppData** - Dynamic data schemas
- **AppMetric/AppIssue/AppWarning** - App monitoring
- **Notification** - User notifications
- **MediaFile** - File uploads and media management
- **BlacklistedToken** - JWT token blacklisting
- **Otp** - One-time passwords for verification

## 🚀 Step 6: Running the Project

### Option A: Using Docker (Recommended)
```bash
# From project root directory
docker-compose up --build

# This will start:
# - Frontend: http://localhost:3000
# - Backend: http://localhost:5000  
# - PostgreSQL: localhost:5432
```

### Option B: Manual Development Setup
```bash
# Terminal 1: Start PostgreSQL (if not using Docker)
# Make sure PostgreSQL is running on port 5432

# Terminal 2: Start Backend
cd server
npm run dev
# Backend will run on http://localhost:5000

# Terminal 3: Start Frontend  
cd client
npm run dev
# Frontend will run on http://localhost:3000
```

## 🧪 Step 7: Testing the Setup

### Run Automated Tests
```bash
# Test backend functionality
cd server
npm test

# Test complete platform (from project root)
node test-platform.js
```

### Manual Testing
1. Open http://localhost:3000 in your browser
2. Login with demo credentials:
   - **Email**: demo@example.com
   - **Password**: Demo123!@#
3. Navigate to Dashboard
4. Create a new app or use templates
5. Test the canvas editor (drag & drop functionality)

## 🔍 Step 8: Development Workflow

### Project Structure
```
FloNeo/
├── client/                 # Next.js Frontend
│   ├── app/               # Next.js 14 App Router
│   ├── components/        # React Components
│   ├── lib/              # Utilities and helpers
│   └── public/           # Static assets
├── server/                # Node.js Backend
│   ├── routes/           # API endpoints
│   ├── prisma/           # Database schema & migrations
│   ├── tests/            # Backend tests
│   └── utils/            # Backend utilities
├── docker-compose.yml     # Docker configuration
└── test-platform.js      # E2E testing script
```

### Key Development Commands
```bash
# Backend development
cd server
npm run dev          # Start development server
npm test            # Run tests
npx prisma studio   # Database GUI
npx prisma migrate dev  # Create new migration

# Frontend development  
cd client
npm run dev         # Start development server
npm run build       # Build for production
npm run lint        # Run ESLint

# Docker commands
docker-compose up --build    # Rebuild and start all services
docker-compose logs frontend # View frontend logs
docker-compose logs backend  # View backend logs
```

## 🐛 Troubleshooting

### Common Issues

**1. Port Already in Use**
```bash
# Kill processes on ports 3000, 5000, or 5432
# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# macOS/Linux:
lsof -ti:3000 | xargs kill -9
```

**2. Database Connection Issues**
- Ensure PostgreSQL is running
- Check DATABASE_URL in server/.env
- Verify database credentials
- Run: `docker-compose logs postgres`

**3. Prisma Client Issues**
```bash
cd server
npx prisma generate
npx prisma migrate reset  # ⚠️ This will reset all data
```

**4. Docker Issues**
```bash
# Reset Docker environment
docker-compose down -v
docker system prune -f
docker-compose up --build
```

**5. Frontend Build Issues**
```bash
cd client
rm -rf .next node_modules
npm install
npm run build
```

### Getting Help
- Check the console logs (F12 in browser)
- Review Docker logs: `docker-compose logs`
- Ensure all environment variables are set correctly
- Verify all services are running: `docker-compose ps`

## 🎯 Next Steps

After successful setup:
1. Explore the canvas editor functionality
2. Create test applications using templates
3. Review the codebase structure
4. Check out the API documentation in `server/routes/`
5. Run the complete test suite to ensure everything works

## 📞 Support

If you encounter issues:
1. Check this troubleshooting guide first
2. Review the project's GitHub issues
3. Contact the development team
4. Ensure you're using the correct Node.js and Docker versions

---

**🎉 Congratulations! You're now ready to contribute to the FloNeo LCNC Platform!**
