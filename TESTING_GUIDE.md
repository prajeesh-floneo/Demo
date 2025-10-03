# 🧪 Runtime Testing Guide

## ⚠️ CRITICAL FIRST STEP: Clear Browser Cache

Before testing, you **MUST** clear your browser cache to see the new changes.

### Method 1: Hard Refresh (Recommended)
- **Windows/Linux:** Press `Ctrl + Shift + R`
- **Mac:** Press `Cmd + Shift + R`

### Method 2: DevTools
1. Open DevTools (F12)
2. Go to **Network** tab
3. Check **"Disable cache"**
4. Refresh the page (F5)

---

## 📋 Test Checklist

### Test 1: Visual Parity

**Goal:** Verify that Run App visuals match the Editor preview exactly.

**Steps:**
1. Open the Editor at http://localhost:3000/editor
2. Create a new page or open an existing one
3. Add the following controls:
   - Text Field
   - Text Area
   - Button
   - Dropdown
   - Checkbox
   - Radio Button
   - Toggle
   - Date Field
   - Phone Field
   - Email Field
   - Password Field
   - Number Field
   - File Upload

4. Apply distinctive styling to each control:
   - **Background:** Different colors (e.g., #f0f9ff, #fef3c7, #fce7f3)
   - **Border:** 2px solid with different colors (e.g., #3b82f6, #10b981, #f59e0b)
   - **Border Radius:** 8px
   - **Shadow:** 0 4px 6px rgba(0,0,0,0.1)
   - **Font:** Poppins, 16px, weight 600
   - **Padding:** 12px
   - **Opacity:** 0.9

5. Save the page

6. Navigate to `/run?appId=<appId>&pageId=<pageId>`

7. **Verify:**
   - ✅ Element count matches Editor
   - ✅ Background colors match exactly
   - ✅ Borders match (width, color, radius)
   - ✅ Shadows match
   - ✅ Fonts match (family, size, weight, color)
   - ✅ Padding matches
   - ✅ Opacity matches
   - ✅ Layout matches (positions, sizes)

---

### Test 2: Functional Parity

**Goal:** Verify that all form controls are interactive and functional.

**Steps:**
1. Navigate to `/run?appId=<appId>&pageId=<pageId>`
2. Open DevTools Console (F12)

**Test Each Control:**

#### Text Field
- ✅ Click to focus
- ✅ Type text
- ✅ Text appears in the field
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Text Area
- ✅ Click to focus
- ✅ Type multi-line text
- ✅ Text appears in the area
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Button
- ✅ Click the button
- ✅ Console shows `[RUNTIME EVENT]` with type: "click"

#### Dropdown
- ✅ Click to open dropdown
- ✅ Select an option
- ✅ Selected value appears
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Checkbox
- ✅ Click to toggle
- ✅ Checkbox state changes
- ✅ Console shows `[RUNTIME EVENT]` with checked state

#### Radio Button
- ✅ Click to select
- ✅ Radio button state changes
- ✅ Console shows `[RUNTIME EVENT]` with checked state

#### Toggle
- ✅ Click to toggle
- ✅ Toggle animates (slider moves)
- ✅ Background color changes
- ✅ Console shows `[RUNTIME EVENT]` with checked state

#### Date Field
- ✅ Click to open date picker
- ✅ Select a date
- ✅ Date appears in the field
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Phone Field
- ✅ Click to focus
- ✅ Type phone number
- ✅ Number appears in the field
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Email Field
- ✅ Click to focus
- ✅ Type email address
- ✅ Email appears in the field
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Password Field
- ✅ Click to focus
- ✅ Type password
- ✅ Password is masked (dots/asterisks)
- ✅ Console shows `[RUNTIME EVENT]` on change

#### Number Field
- ✅ Click to focus
- ✅ Type numbers
- ✅ Numbers appear in the field
- ✅ Console shows `[RUNTIME EVENT]` on change

#### File Upload
- ✅ Click to open file chooser
- ✅ Select a file
- ✅ File name appears
- ✅ Console shows `[RUNTIME EVENT]` with file name

---

### Test 3: Console Logging

**Goal:** Verify that all required logs are present.

**Steps:**
1. Navigate to `/run?appId=<appId>&pageId=<pageId>`
2. Open DevTools Console (F12)

**Verify Logs:**

#### On Page Load
```
[RUN] appId, pageId: <appId>, <pageId>
[RUN] pages: <count>, [{ id: <id>, el: <elementCount> }, ...]
🔍 RUN: Rendering canvas with: {
  currentPageId: <id>,
  currentPageName: <name>,
  elementCount: <count>,
  canvasWidth: <width>,
  canvasHeight: <height>,
  canvasDimensions: "<width>x<height>"
}
🔍 RUN: First 3 elements: [
  { id: <id>, type: <type>, pos: "<x>,<y>", size: "<w>x<h>" },
  ...
]
```

#### On Interaction
```
[RUNTIME EVENT] { id: <elementId>, type: "click", data: undefined }
[RUNTIME EVENT] { id: <elementId>, type: "change", data: { value: "..." } }
```

---

### Test 4: 1:1 Scale Rendering

**Goal:** Verify that the canvas renders at exact dimensions without transforms.

**Steps:**
1. In the Editor, set canvas dimensions to 960x640
2. Save the page
3. Navigate to `/run?appId=<appId>&pageId=<pageId>`
4. Open DevTools Console (F12)

**Verify:**
- ✅ Console shows: `canvasWidth: 960, canvasHeight: 640`
- ✅ Canvas is centered on the page
- ✅ Canvas has a subtle shadow
- ✅ No zoom/pan transforms applied
- ✅ Elements are at exact positions (no scaling)

**Visual Check:**
1. Right-click on the canvas container
2. Inspect element
3. Verify the div has:
   ```css
   width: 960px;
   height: 640px;
   position: relative;
   ```

---

### Test 5: Disabled State

**Goal:** Verify that disabled controls are properly styled and non-interactive.

**Steps:**
1. In the Editor, set a control to disabled
2. Save the page
3. Navigate to `/run?appId=<appId>&pageId=<pageId>`

**Verify:**
- ✅ Disabled controls have reduced opacity (0.5)
- ✅ Disabled controls cannot be interacted with
- ✅ Cursor does not change to pointer on hover

---

## 🐛 Troubleshooting

### Issue: Changes not visible
**Solution:** Clear browser cache with Ctrl+Shift+R

### Issue: Console logs not appearing
**Solution:** 
1. Check that DevTools Console is open (F12)
2. Verify you're on the `/run` page, not `/editor`
3. Check Console filter settings (should show all logs)

### Issue: Controls not interactive
**Solution:**
1. Verify you're in preview mode (URL should be `/run?appId=...`)
2. Check Console for errors
3. Verify the control is not disabled

### Issue: Styles don't match Editor
**Solution:**
1. Clear browser cache
2. Verify the page was saved after styling
3. Check Console for `🔍 RUN:` logs to verify element count

---

## ✅ Expected Results

After completing all tests, you should see:

1. **Visual Parity:** ✅ Run App looks identical to Editor preview
2. **Functional Parity:** ✅ All controls are interactive and work correctly
3. **Console Logs:** ✅ All required logs appear in Console
4. **1:1 Scale:** ✅ Canvas renders at exact dimensions
5. **Disabled State:** ✅ Disabled controls are properly styled

---

## 📊 Test Report Template

Use this template to report test results:

```
## Test Results

**Date:** <date>
**Tester:** <name>
**Browser:** <browser name and version>

### Visual Parity
- [ ] Element count matches
- [ ] Background colors match
- [ ] Borders match
- [ ] Shadows match
- [ ] Fonts match
- [ ] Padding matches
- [ ] Opacity matches

### Functional Parity
- [ ] Text Field works
- [ ] Text Area works
- [ ] Button works
- [ ] Dropdown works
- [ ] Checkbox works
- [ ] Radio Button works
- [ ] Toggle works
- [ ] Date Field works
- [ ] Phone Field works
- [ ] Email Field works
- [ ] Password Field works
- [ ] Number Field works
- [ ] File Upload works

### Console Logging
- [ ] [RUN] logs appear
- [ ] 🔍 RUN: logs appear
- [ ] [RUNTIME EVENT] logs appear

### 1:1 Scale Rendering
- [ ] Canvas dimensions correct
- [ ] No transforms applied
- [ ] Elements at exact positions

### Issues Found
<list any issues here>

### Overall Status
- [ ] PASS
- [ ] FAIL (see issues above)
```

---

## 🎉 Success Criteria

The implementation is successful if:
1. ✅ All visual parity checks pass
2. ✅ All functional parity checks pass
3. ✅ All console logs appear correctly
4. ✅ Canvas renders at 1:1 scale
5. ✅ No errors in Console

**If all criteria are met, the implementation is COMPLETE and VERIFIED!**

