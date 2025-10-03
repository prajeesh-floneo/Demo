# FloNeo LCNC Platform - Deployment Guide

## Overview

This guide covers deploying the FloNeo LCNC Platform to Render using the Blueprint configuration.

## Architecture

The deployment consists of:
- **PostgreSQL Database** (`floneo-postgres`) - Managed database service
- **Backend API** (`floneo-backend`) - Node.js/Express server with Prisma
- **Frontend** (`floneo-frontend`) - Next.js application
- **Persistent Storage** - Mounted disk for file uploads

## Initial Deployment

### 1. Deploy via Render Blueprint

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New +" → "Blueprint"
3. Connect your GitHub repository
4. Select the branch containing `render.yaml`
5. Click "Apply"

Render will create all services automatically based on the blueprint.

### 2. Monitor Deployment

- **Database**: Should be ready first (~2-3 minutes)
- **Backend**: Will deploy after database is ready (~5-7 minutes)
- **Frontend**: Will deploy in parallel with backend (~3-5 minutes)

### 3. Get Service URLs

After deployment, note the URLs:
- Backend: `https://floneo-backend-XXXXX.onrender.com`
- Frontend: `https://floneo-frontend-XXXXX.onrender.com`

## Post-Deployment Configuration

### 4. Update Environment Variables

#### Backend CORS Configuration
1. Go to Backend service → Environment
2. Update `ALLOWED_ORIGINS`:
   ```
   https://floneo-frontend-XXXXX.onrender.com,http://localhost:3000
   ```
3. Click "Save Changes" → Service will redeploy

#### Frontend API Configuration
1. Go to Frontend service → Environment
2. Update `NEXT_PUBLIC_API_URL`:
   ```
   https://floneo-backend-XXXXX.onrender.com
   ```
3. Update `BACKEND_URL`:
   ```
   https://floneo-backend-XXXXX.onrender.com
   ```
4. Click "Save Changes" → Service will redeploy

## Environment Variables Reference

### Backend (`floneo-backend`)
- `DATABASE_URL` - Auto-generated from PostgreSQL service
- `JWT_SECRET` - Auto-generated secure value
- `JWT_REFRESH_SECRET` - Auto-generated secure value
- `ALLOWED_ORIGINS` - Comma-separated list of allowed origins

### Frontend (`floneo-frontend`)
- `NEXT_PUBLIC_API_URL` - Backend service URL (public)
- `BACKEND_URL` - Backend service URL (server-side)

## Database Management

### Running Migrations
Migrations run automatically via `postDeployCommand`, but to run manually:

1. Go to Backend service → Shell
2. Run: `npx prisma migrate deploy`

### Database Access
1. Go to PostgreSQL service → Info
2. Use connection details for external access
3. Or use Render's built-in database browser

## File Uploads

Uploads are stored on a persistent disk mounted at `/server/uploads`:
- **Size**: 1GB (configurable in `render.yaml`)
- **Persistence**: Survives service restarts and redeployments
- **Access**: Only from backend service

## Custom Domains

### Adding Custom Domain
1. Go to service → Settings → Custom Domains
2. Add your domain (e.g., `api.yourdomain.com`)
3. Update DNS records as instructed
4. Update environment variables with new domains

### Update CORS for Custom Domains
Add custom domains to `ALLOWED_ORIGINS`:
```
https://yourdomain.com,https://api.yourdomain.com,http://localhost:3000
```

## Troubleshooting

### Common Issues

#### Build Failures
- Check build logs in service → Deploys
- Verify `package.json` scripts are correct
- Ensure all dependencies are in `package.json`

#### CORS Errors
- Verify `ALLOWED_ORIGINS` includes frontend URL
- Check browser console for exact error
- Ensure no trailing slashes in URLs

#### Database Connection Issues
- Check `DATABASE_URL` is set correctly
- Verify Prisma schema matches database
- Run migrations if needed

#### File Upload Issues
- Check disk is mounted at `/server/uploads`
- Verify upload directory permissions
- Check disk usage in service dashboard

### Rollback Procedure
1. Go to service → Deploys
2. Find previous successful deploy
3. Click "Redeploy" on that version

## Monitoring

### Health Checks
- Backend: `GET /health` returns service status
- Frontend: Automatic health checks via Render

### Logs
- Access logs via service → Logs
- Filter by service and time range
- Download logs for analysis

## Scaling

### Upgrading Plans
1. Go to service → Settings
2. Change plan (Starter → Standard → Pro)
3. Adjust resources as needed

### Database Scaling
1. Go to PostgreSQL service → Settings
2. Upgrade plan for more storage/performance
3. Note: Cannot downgrade database plans

## Security

### Environment Variables
- Never commit `.env` files
- Use Render's environment variable management
- Rotate secrets regularly

### Database Security
- Database is isolated within Render's network
- Use strong passwords (auto-generated)
- Regular backups are automatic

## Support

For deployment issues:
1. Check Render status page
2. Review service logs
3. Contact Render support
4. Check FloNeo documentation
