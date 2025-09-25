const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');
const crypto = require('crypto');

// UUID v4 generator function
const uuidv4 = () => {
  return crypto.randomUUID();
};

const router = express.Router();
const prisma = new PrismaClient();

let io; // Socket.io instance

// Inject Socket.io instance
const setSocketIO = (socketInstance) => {
  io = socketInstance;
};

// ===== CANVAS MANAGEMENT =====

// GET /api/canvas/:appId - Get canvas for an app
router.get('/:appId', authenticateToken, async (req, res) => {
  try {
    const { appId } = req.params;
    const userId = req.user.id;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    // Get or create canvas
    let canvas = await prisma.canvas.findUnique({
      where: { appId: parseInt(appId) },
      include: {
        elements: {
          include: {
            interactions: true,
            validations: true,
            children: true
          },
          orderBy: { zIndex: 'asc' }
        }
      }
    });

    if (!canvas) {
      // Create default canvas
      canvas = await prisma.canvas.create({
        data: {
          appId: parseInt(appId),
          name: `${app.name} Canvas`,
          description: 'Drag-and-drop canvas interface'
        },
        include: {
          elements: {
            include: {
              interactions: true,
              validations: true,
              children: true
            },
            orderBy: { zIndex: 'asc' }
          }
        }
      });
    }

    res.json({
      success: true,
      data: canvas
    });

  } catch (error) {
    console.error('Get canvas error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve canvas'
    });
  }
});

// PUT /api/canvas/:appId - Update canvas properties
router.put('/:appId', authenticateToken, async (req, res) => {
  try {
    const { appId } = req.params;
    const userId = req.user.id;
    const { name, description, width, height, background, gridEnabled, snapEnabled, zoomLevel } = req.body;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    const canvas = await prisma.canvas.update({
      where: { appId: parseInt(appId) },
      data: {
        ...(name && { name }),
        ...(description !== undefined && { description }),
        ...(width && { width }),
        ...(height && { height }),
        ...(background && { background }),
        ...(gridEnabled !== undefined && { gridEnabled }),
        ...(snapEnabled !== undefined && { snapEnabled }),
        ...(zoomLevel && { zoomLevel })
      },
      include: {
        elements: {
          include: {
            interactions: true,
            validations: true,
            children: true
          },
          orderBy: { zIndex: 'asc' }
        }
      }
    });

    // Record history
    await prisma.canvasHistory.create({
      data: {
        canvasId: canvas.id,
        action: 'canvas_update',
        newState: { name, description, width, height, background, gridEnabled, snapEnabled, zoomLevel },
        userId
      }
    });

    // Emit real-time update
    if (io) {
      io.to(`app:${appId}`).emit('canvas:updated', {
        appId: parseInt(appId),
        canvas,
        updatedBy: userId,
        timestamp: new Date()
      });
    }

    res.json({
      success: true,
      data: canvas
    });

  } catch (error) {
    console.error('Update canvas error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update canvas'
    });
  }
});

// ===== ELEMENT MANAGEMENT =====

// POST /api/canvas/:appId/elements - Create new element
router.post('/:appId/elements', authenticateToken, async (req, res) => {
  try {
    const { appId } = req.params;
    const userId = req.user.id;
    const {
      type,
      name,
      x = 0,
      y = 0,
      width = 100,
      height = 50,
      rotation = 0,
      zIndex = 0,
      groupId,
      parentId,
      properties = {},
      styles = {},
      constraints = {}
    } = req.body;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    // Get canvas
    const canvas = await prisma.canvas.findUnique({
      where: { appId: parseInt(appId) }
    });

    if (!canvas) {
      return res.status(404).json({
        success: false,
        message: 'Canvas not found'
      });
    }

    // Generate unique element ID
    const elementId = uuidv4();

    // Create element
    const element = await prisma.canvasElement.create({
      data: {
        canvasId: canvas.id,
        elementId,
        type,
        name: name || `${type} Element`,
        x: parseFloat(x),
        y: parseFloat(y),
        width: parseFloat(width),
        height: parseFloat(height),
        rotation: parseFloat(rotation),
        zIndex: parseInt(zIndex),
        groupId,
        parentId: parentId ? parseInt(parentId) : null,
        properties,
        styles,
        constraints
      },
      include: {
        interactions: true,
        validations: true,
        children: true
      }
    });

    // Record history
    await prisma.canvasHistory.create({
      data: {
        canvasId: canvas.id,
        action: 'element_create',
        elementId,
        newState: element,
        userId
      }
    });

    // Emit real-time update
    if (io) {
      io.to(`app:${appId}`).emit('element:created', {
        appId: parseInt(appId),
        element,
        createdBy: userId,
        timestamp: new Date()
      });
    }

    res.status(201).json({
      success: true,
      data: element
    });

  } catch (error) {
    console.error('Create element error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create element'
    });
  }
});

// PUT /api/canvas/:appId/elements/:elementId - Update element
router.put('/:appId/elements/:elementId', authenticateToken, async (req, res) => {
  try {
    const { appId, elementId } = req.params;
    const userId = req.user.id;
    const updateData = req.body;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    // Get current element state for history
    const currentElement = await prisma.canvasElement.findUnique({
      where: { elementId },
      include: {
        interactions: true,
        validations: true,
        children: true
      }
    });

    if (!currentElement) {
      return res.status(404).json({
        success: false,
        message: 'Element not found'
      });
    }

    // Update element
    const element = await prisma.canvasElement.update({
      where: { elementId },
      data: {
        ...(updateData.name && { name: updateData.name }),
        ...(updateData.x !== undefined && { x: parseFloat(updateData.x) }),
        ...(updateData.y !== undefined && { y: parseFloat(updateData.y) }),
        ...(updateData.width !== undefined && { width: parseFloat(updateData.width) }),
        ...(updateData.height !== undefined && { height: parseFloat(updateData.height) }),
        ...(updateData.rotation !== undefined && { rotation: parseFloat(updateData.rotation) }),
        ...(updateData.zIndex !== undefined && { zIndex: parseInt(updateData.zIndex) }),
        ...(updateData.locked !== undefined && { locked: updateData.locked }),
        ...(updateData.visible !== undefined && { visible: updateData.visible }),
        ...(updateData.groupId !== undefined && { groupId: updateData.groupId }),
        ...(updateData.parentId !== undefined && { parentId: updateData.parentId ? parseInt(updateData.parentId) : null }),
        ...(updateData.properties && { properties: updateData.properties }),
        ...(updateData.styles && { styles: updateData.styles }),
        ...(updateData.constraints && { constraints: updateData.constraints })
      },
      include: {
        interactions: true,
        validations: true,
        children: true
      }
    });

    // Record history
    await prisma.canvasHistory.create({
      data: {
        canvasId: currentElement.canvasId,
        action: 'element_update',
        elementId,
        oldState: currentElement,
        newState: element,
        userId
      }
    });

    // Emit real-time update
    if (io) {
      io.to(`app:${appId}`).emit('element:updated', {
        appId: parseInt(appId),
        element,
        updatedBy: userId,
        timestamp: new Date()
      });
    }

    res.json({
      success: true,
      data: element
    });

  } catch (error) {
    console.error('Update element error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update element'
    });
  }
});

// DELETE /api/canvas/:appId/elements/:elementId - Delete element
router.delete('/:appId/elements/:elementId', authenticateToken, async (req, res) => {
  try {
    const { appId, elementId } = req.params;
    const userId = req.user.id;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    // Get element for history
    const element = await prisma.canvasElement.findUnique({
      where: { elementId },
      include: {
        interactions: true,
        validations: true,
        children: true
      }
    });

    if (!element) {
      return res.status(404).json({
        success: false,
        message: 'Element not found'
      });
    }

    // Delete element (cascade will handle interactions and validations)
    await prisma.canvasElement.delete({
      where: { elementId }
    });

    // Record history
    await prisma.canvasHistory.create({
      data: {
        canvasId: element.canvasId,
        action: 'element_delete',
        elementId,
        oldState: element,
        userId
      }
    });

    // Emit real-time update
    if (io) {
      io.to(`app:${appId}`).emit('element:deleted', {
        appId: parseInt(appId),
        elementId,
        deletedBy: userId,
        timestamp: new Date()
      });
    }

    res.json({
      success: true,
      message: 'Element deleted successfully'
    });

  } catch (error) {
    console.error('Delete element error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete element'
    });
  }
});

// PATCH /api/canvas/:appId/state - Save complete canvas state
router.patch('/:appId/state', authenticateToken, async (req, res) => {
  try {
    const { appId } = req.params;
    const userId = req.user.id;
    const { canvasState } = req.body;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    // Get or create canvas
    let canvas = await prisma.canvas.findUnique({
      where: { appId: parseInt(appId) }
    });

    if (!canvas) {
      canvas = await prisma.canvas.create({
        data: {
          appId: parseInt(appId),
          name: canvasState.name || 'Untitled Canvas',
          width: canvasState.width || 1200,
          height: canvasState.height || 800,
          background: canvasState.background || { color: '#ffffff', opacity: 100 }
        }
      });
    }

    // Clear existing elements for this canvas
    await prisma.canvasElement.deleteMany({
      where: { canvasId: canvas.id }
    });

    // Also delete any existing elements with the same elementIds globally to avoid unique constraint issues
    if (canvasState.elements && Array.isArray(canvasState.elements)) {
      const elementIds = canvasState.elements.map(el => el.id).filter(Boolean);
      if (elementIds.length > 0) {
        await prisma.canvasElement.deleteMany({
          where: {
            elementId: { in: elementIds }
          }
        });
      }
    }

    // Create new elements from canvas state
    const elementsToCreate = [];
    if (canvasState.elements && Array.isArray(canvasState.elements)) {
      for (const element of canvasState.elements) {
        // Generate a unique elementId if not provided or ensure uniqueness
        const elementId = element.id || `${element.type}-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

        elementsToCreate.push({
          canvasId: canvas.id,
          elementId: elementId,
          type: element.type || 'SHAPE',
          name: element.name || 'Untitled Element',
          x: parseFloat(element.x) || 0,
          y: parseFloat(element.y) || 0,
          width: parseFloat(element.width) || 100,
          height: parseFloat(element.height) || 50,
          rotation: parseFloat(element.rotation) || 0,
          zIndex: parseInt(element.zIndex) || 0,
          locked: Boolean(element.properties?.locked) || false,
          visible: !Boolean(element.properties?.hidden),
          groupId: element.groupId || null,
          properties: element.properties || {},
          styles: {
            backgroundColor: element.properties?.backgroundColor,
            color: element.properties?.color,
            fontSize: element.properties?.fontSize,
            fontWeight: element.properties?.fontWeight,
            textAlign: element.properties?.textAlign,
            borderRadius: element.properties?.borderRadius,
            borderWidth: element.properties?.borderWidth,
            borderColor: element.properties?.borderColor,
            opacity: element.opacity
          }
        });
      }
    }

    // Bulk create elements
    if (elementsToCreate.length > 0) {
      await prisma.canvasElement.createMany({
        data: elementsToCreate
      });
    }

    // Update canvas properties
    await prisma.canvas.update({
      where: { id: canvas.id },
      data: {
        name: canvasState.name || canvas.name,
        width: canvasState.width || canvas.width,
        height: canvasState.height || canvas.height,
        background: canvasState.background || canvas.background,
        zoomLevel: canvasState.zoomLevel || canvas.zoomLevel
      }
    });

    // Record history
    await prisma.canvasHistory.create({
      data: {
        canvasId: canvas.id,
        action: 'canvas_state_save',
        newState: canvasState,
        userId
      }
    });

    // Emit real-time update
    if (io) {
      io.to(`canvas-${appId}`).emit('canvasStateSaved', {
        appId: parseInt(appId),
        canvasState,
        userId
      });
    }

    res.json({
      success: true,
      message: 'Canvas state saved successfully',
      data: {
        canvasId: canvas.id,
        elementsCount: elementsToCreate.length
      }
    });

  } catch (error) {
    console.error('❌ Canvas state save error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to save canvas state',
      error: error.message
    });
  }
});

// POST /api/canvas/:appId/elements/:elementId/duplicate - Duplicate element
router.post('/:appId/elements/:elementId/duplicate', authenticateToken, async (req, res) => {
  try {
    const { appId, elementId } = req.params;
    const userId = req.user.id;
    const { offsetX = 20, offsetY = 20 } = req.body;

    // Verify user owns the app
    const app = await prisma.app.findFirst({
      where: {
        id: parseInt(appId),
        ownerId: userId
      }
    });

    if (!app) {
      return res.status(404).json({
        success: false,
        message: 'App not found or access denied'
      });
    }

    // Get original element
    const originalElement = await prisma.canvasElement.findUnique({
      where: { elementId },
      include: {
        interactions: true,
        validations: true
      }
    });

    if (!originalElement) {
      return res.status(404).json({
        success: false,
        message: 'Element not found'
      });
    }

    // Generate new element ID
    const newElementId = uuidv4();

    // Create duplicate element
    const duplicateElement = await prisma.canvasElement.create({
      data: {
        canvasId: originalElement.canvasId,
        elementId: newElementId,
        type: originalElement.type,
        name: `${originalElement.name} Copy`,
        x: originalElement.x + offsetX,
        y: originalElement.y + offsetY,
        width: originalElement.width,
        height: originalElement.height,
        rotation: originalElement.rotation,
        zIndex: originalElement.zIndex + 1,
        locked: originalElement.locked,
        visible: originalElement.visible,
        groupId: originalElement.groupId,
        parentId: originalElement.parentId,
        properties: originalElement.properties,
        styles: originalElement.styles,
        constraints: originalElement.constraints
      },
      include: {
        interactions: true,
        validations: true,
        children: true
      }
    });

    // Duplicate interactions
    for (const interaction of originalElement.interactions) {
      await prisma.elementInteraction.create({
        data: {
          elementId: duplicateElement.id,
          event: interaction.event,
          action: interaction.action
        }
      });
    }

    // Duplicate validations
    for (const validation of originalElement.validations) {
      await prisma.elementValidation.create({
        data: {
          elementId: duplicateElement.id,
          rule: validation.rule,
          value: validation.value,
          message: validation.message
        }
      });
    }

    // Record history
    await prisma.canvasHistory.create({
      data: {
        canvasId: originalElement.canvasId,
        action: 'element_duplicate',
        elementId: newElementId,
        newState: duplicateElement,
        userId
      }
    });

    // Emit real-time update
    if (io) {
      io.to(`app:${appId}`).emit('element:duplicated', {
        appId: parseInt(appId),
        originalElementId: elementId,
        duplicateElement,
        duplicatedBy: userId,
        timestamp: new Date()
      });
    }

    res.status(201).json({
      success: true,
      data: duplicateElement
    });

  } catch (error) {
    console.error('Duplicate element error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to duplicate element'
    });
  }
});

module.exports = router;
module.exports.setSocketIO = setSocketIO;
