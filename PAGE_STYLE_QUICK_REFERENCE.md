# 🎨 Page Style Quick Reference

## ⚠️ FIRST: Clear Browser Cache
**Press `Ctrl + Shift + R` before testing!**

---

## 📋 What's New

Canvas pages now support:
- ✅ **Solid backgrounds** - Any color
- ✅ **Gradient backgrounds** - Linear gradients with custom angles
- ✅ **Image backgrounds** - Local or remote images
- ✅ **Image + Gradient** - Layered backgrounds
- ✅ **Borders** - Width and color
- ✅ **Border radius** - Rounded corners
- ✅ **Box shadows** - Drop shadows

---

## 🔍 How to Verify It's Working

### 1. Check Console Logs
Open DevTools (F12) → Console tab

**On page load, you should see:**
```
[RUN] page.canvasBackground: {"type":"color","color":"#f0f9ff"}
[RUN] canvasStyle: { backgroundColor: '#f0f9ff', ... }
[RUN] pageStyleHash: 1a2b3c4d
```

### 2. Visual Check
- Canvas should have the background you set in the Editor
- Border, radius, and shadow should match Editor preview
- No white background if you set a color/gradient/image

---

## 🎨 Background Type Examples

### Solid Color
**Editor:** Set canvas background to solid color
**Result:** Canvas has that color as background

### Gradient
**Editor:** Set canvas background to gradient
**Result:** Canvas shows gradient (e.g., blue to purple)

### Image
**Editor:** Set canvas background to image
**Result:** Canvas shows image as background

### Image + Gradient
**Editor:** Set both image and gradient
**Result:** Canvas shows image with gradient overlay

---

## 🐛 Common Issues

### Background not showing?
1. **Clear cache:** `Ctrl + Shift + R`
2. **Check Console:** Look for `[RUN] canvasStyle:` log
3. **Verify save:** Make sure you saved the page in Editor

### Image not loading?
1. **Check URL:** Verify image URL is correct
2. **Check Network tab:** Look for 404 errors
3. **For local images:** Ensure file is in `public/uploads/`
4. **For external images:** Check CORS headers

### Gradient not rendering?
1. **Check Console:** Look for `backgroundImage` in `canvasStyle` log
2. **Verify gradient:** Ensure at least 2 color stops
3. **Clear cache:** `Ctrl + Shift + R`

---

## 📊 Console Log Reference

### Expected Logs on Page Load

```javascript
// 1. App and page info
[RUN] appId, pageId: 2, page-1

// 2. Pages array
[RUN] pages: 1, [{ id: 'page-1', el: 5 }]

// 3. Page details
[RUN] page.id: page-1
[RUN] page.canvasWidth/Height: 960, 640

// 4. Background data (legacy format)
[RUN] page.canvasBackground: {"type":"color","color":"#f0f9ff"}

// 5. New style format (if available)
[RUN] page.style: undefined

// 6. Canvas rendering info
🔍 RUN: Rendering canvas with: {
  currentPageId: 'page-1',
  currentPageName: 'Home',
  elementCount: 5,
  canvasWidth: 960,
  canvasHeight: 640
}

// 7. Computed canvas style
[RUN] canvasStyle: {
  width: 960,
  height: 640,
  position: 'relative',
  overflow: 'hidden',
  backgroundColor: '#f0f9ff',
  backgroundImage: undefined,
  borderStyle: 'none',
  borderWidth: 0,
  borderRadius: 0,
  boxShadow: 'none'
}

// 8. Style hash for debugging
[RUN] pageStyleHash: 1a2b3c4d
```

---

## ✅ Quick Test Checklist

- [ ] Clear browser cache (`Ctrl + Shift + R`)
- [ ] Open Editor at http://localhost:3000/editor
- [ ] Set canvas background (color/gradient/image)
- [ ] Save the page
- [ ] Navigate to `/run?appId=<appId>&pageId=<pageId>`
- [ ] Open DevTools Console (F12)
- [ ] Verify `[RUN] canvasStyle:` log shows correct background
- [ ] Verify canvas visually matches Editor preview

---

## 🎯 Files Modified

1. **Created:** `client/runtime/pageStyle.ts` - Page style mapper
2. **Updated:** `client/app/run/page.tsx` - Run App page
3. **Updated:** `client/app/preview/[appId]/page.tsx` - Preview page

---

## 🚀 System Status

- ✅ Frontend: Running at http://localhost:3000
- ✅ Backend: Running at http://localhost:5000
- ✅ Database: PostgreSQL running
- ✅ All code: Deployed and active

---

## 📞 Need Help?

If something isn't working:
1. Check this guide's "Common Issues" section
2. Look at Console logs for errors
3. Verify you cleared browser cache
4. Check Network tab for failed requests

**Remember:** Always clear cache with `Ctrl + Shift + R` after Docker rebuilds!

