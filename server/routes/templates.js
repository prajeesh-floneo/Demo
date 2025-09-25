const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');
const {
  createStandardError,
  asyncHandler,
  createSuccessResponse
} = require('../utils/errorHandler');

const router = express.Router();
const prisma = new PrismaClient();

// Socket.io instance will be injected
let io;

// All routes require authentication
router.use(authenticateToken);

// GET /api/templates - List all templates (Dashboard Templates section)
router.get('/', asyncHandler(async (req, res) => {
  const { search, category } = req.query;

  // Build where clause for search
  const where = {};

  if (search && search.trim()) {
    where.OR = [
      { name: { contains: search, mode: 'insensitive' } },
      { description: { contains: search, mode: 'insensitive' } },
      { category: { contains: search, mode: 'insensitive' } }
    ];
  }

  if (category && category !== 'all') {
    where.category = category;
  }

  const templates = await prisma.template.findMany({
    where,
    select: {
      id: true,
      name: true,
      description: true,
      preview_image: true,
      category: true,
      createdAt: true
    },
    orderBy: { name: 'asc' }
  });

    // Emit Socket.io event for template access
    if (io) {
      io.emit('template:accessed', {
        userId: req.user.id,
        userEmail: req.user.email,
        action: 'templates_listed',
        templateCount: templates.length,
        categories: [...new Set(templates.map(t => t.category))],
        timestamp: new Date().toISOString()
      });
    }

  res.json(createSuccessResponse('Templates retrieved successfully', {
    templates,
    count: templates.length
  }));
}));

// Function to inject Socket.io instance
router.setSocketIO = (socketIO) => {
  io = socketIO;
};

module.exports = router;
