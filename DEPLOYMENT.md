# 🚀 Deployment Guide

This project is configured for deployment on **Railway** (backend) and **Vercel** (frontend).

## 📁 Project Structure

```
floneo_redirect/
├── server/          # Backend API (Railway)
│   ├── railway.json # Railway configuration
│   ├── package.json
│   ├── prisma/
│   └── ...
├── client/          # Frontend (Vercel)
│   ├── vercel.json  # Vercel configuration
│   ├── package.json
│   ├── app/
│   └── ...
└── README.md
```

## 🚂 Railway Deployment (Backend)

### Prerequisites
1. Create a Railway account at [railway.app](https://railway.app)
2. Install Railway CLI: `npm install -g @railway/cli`

### Steps
1. **Login to Railway**
   ```bash
   railway login
   ```

2. **Create New Project**
   ```bash
   cd server
   railway init
   ```

3. **Add PostgreSQL Database**
   ```bash
   railway add postgresql
   ```

4. **Deploy**
   ```bash
   railway up
   ```

### Environment Variables (Railway)
Set these in Railway dashboard:
```
DATABASE_URL=postgresql://... (auto-generated)
JWT_SECRET=your-super-secret-jwt-key
JWT_REFRESH_SECRET=your-super-secret-refresh-key
ALLOWED_ORIGINS=https://your-vercel-app.vercel.app,http://localhost:3000
NODE_ENV=production
PORT=3000
```

## ⚡ Vercel Deployment (Frontend)

### Prerequisites
1. Create a Vercel account at [vercel.com](https://vercel.com)
2. Install Vercel CLI: `npm install -g vercel`

### Steps
1. **Login to Vercel**
   ```bash
   vercel login
   ```

2. **Deploy from client directory**
   ```bash
   cd client
   vercel
   ```

3. **Follow prompts**
   - Link to existing project or create new
   - Set build settings (auto-detected)

### Environment Variables (Vercel)
Set these in Vercel dashboard:
```
NEXT_PUBLIC_API_URL=https://your-railway-app.railway.app
```

## 🔗 Connecting Frontend to Backend

1. **Get Railway Backend URL**
   - Go to Railway dashboard
   - Copy your service URL (e.g., `https://your-app.railway.app`)

2. **Update Vercel Environment Variables**
   - Go to Vercel dashboard → Project → Settings → Environment Variables
   - Set `NEXT_PUBLIC_API_URL` to your Railway URL

3. **Update Railway CORS**
   - Go to Railway dashboard → Environment Variables
   - Update `ALLOWED_ORIGINS` to include your Vercel URL

## 🔄 Automatic Deployments

Both platforms support automatic deployments:

- **Railway**: Deploys on push to `main` branch (server/ changes)
- **Vercel**: Deploys on push to `main` branch (client/ changes)

## 🛠️ Local Development

1. **Backend (Railway)**
   ```bash
   cd server
   npm install
   railway run npm run dev
   ```

2. **Frontend (Vercel)**
   ```bash
   cd client
   npm install
   vercel dev
   ```

## 📊 Monitoring

- **Railway**: Built-in metrics and logs
- **Vercel**: Analytics and function logs
- **Database**: Railway PostgreSQL metrics

## 🔧 Troubleshooting

### Common Issues

1. **CORS Errors**
   - Check `ALLOWED_ORIGINS` in Railway
   - Ensure Vercel URL is included

2. **Database Connection**
   - Verify `DATABASE_URL` in Railway
   - Check Prisma migrations

3. **Build Failures**
   - Check build logs in respective platforms
   - Verify environment variables

### Support
- Railway: [docs.railway.app](https://docs.railway.app)
- Vercel: [vercel.com/docs](https://vercel.com/docs)
