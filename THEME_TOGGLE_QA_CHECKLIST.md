# 🧪 DARK/LIGHT THEME TOGGLE - QA CHECKLIST

## Quick Testing Guide for Theme Toggle Feature

---

## ✅ Pre-Testing Setup

- [ ] Clear browser cache (`Ctrl + Shift + R` or `Cmd + Shift + R`)
- [ ] Open Browser Console (`F12` → Console tab)
- [ ] Ensure Docker containers are running (`docker compose ps`)
- [ ] Navigate to `http://localhost:3000`

---

## 📋 Test Cases

### Test 1: Dashboard Page - Theme Toggle Visibility
**Page:** `http://localhost:3000/dashboard`

- [ ] **Step 1:** Login to the dashboard
- [ ] **Step 2:** Look for theme toggle icon in top-right corner of header
- [ ] **Step 3:** Verify icon is visible (Moon 🌙 in Light mode)
- [ ] **Step 4:** Verify icon is positioned between "Welcome, {email}" and "Logout" button

**Expected Result:**
- ✅ Moon icon visible in Light mode
- ✅ Icon is properly aligned in header
- ✅ Icon has hover effect (background changes on hover)

---

### Test 2: Dashboard Page - Theme Switch to Dark
**Page:** `http://localhost:3000/dashboard`

- [ ] **Step 1:** Click the Moon icon
- [ ] **Step 2:** Observe the page transition
- [ ] **Step 3:** Verify icon changes to Sun (🌞)
- [ ] **Step 4:** Verify background changes from light gradient to dark gray
- [ ] **Step 5:** Verify text colors change to light colors
- [ ] **Step 6:** Check console for log: `"Theme switched to Dark"`

**Expected Result:**
- ✅ Instant theme switch (no page reload)
- ✅ Icon changes from Moon to Sun
- ✅ Background: `dark:from-gray-900 dark:via-gray-800 dark:to-gray-900`
- ✅ Header: `dark:bg-gray-900/50`, `dark:border-gray-700/50`
- ✅ Text: `dark:text-gray-100`, `dark:text-gray-300`
- ✅ Console log present

---

### Test 3: Dashboard Page - Theme Switch to Light
**Page:** `http://localhost:3000/dashboard`

- [ ] **Step 1:** Click the Sun icon (while in Dark mode)
- [ ] **Step 2:** Observe the page transition
- [ ] **Step 3:** Verify icon changes to Moon (🌙)
- [ ] **Step 4:** Verify background changes from dark to light gradient
- [ ] **Step 5:** Verify text colors change to dark colors
- [ ] **Step 6:** Check console for log: `"Theme switched to Light"`

**Expected Result:**
- ✅ Instant theme switch (no page reload)
- ✅ Icon changes from Sun to Moon
- ✅ Background returns to light gradient
- ✅ All colors return to light mode
- ✅ Console log present

---

### Test 4: Canvas Page - Theme Toggle Visibility
**Page:** `http://localhost:3000/canvas`

- [ ] **Step 1:** Navigate to Canvas page
- [ ] **Step 2:** Look for theme toggle icon in header toolbar
- [ ] **Step 3:** Verify icon is visible (Moon 🌙 in Light mode)
- [ ] **Step 4:** Verify icon is positioned before "Save" button

**Expected Result:**
- ✅ Moon icon visible in Light mode
- ✅ Icon is properly aligned in toolbar
- ✅ Icon has hover effect

---

### Test 5: Canvas Page - Theme Switch
**Page:** `http://localhost:3000/canvas`

- [ ] **Step 1:** Click the Moon icon
- [ ] **Step 2:** Verify icon changes to Sun (🌞)
- [ ] **Step 3:** Verify background changes to `dark:bg-gray-900`
- [ ] **Step 4:** Verify header changes to `dark:bg-gray-800`, `dark:border-gray-700`
- [ ] **Step 5:** Verify app name text changes to `dark:text-gray-100`
- [ ] **Step 6:** Check console for log: `"Theme switched to Dark"`

**Expected Result:**
- ✅ Instant theme switch
- ✅ All dark mode classes applied correctly
- ✅ Console log present

---

### Test 6: Workflow Page - Theme Toggle Visibility
**Page:** `http://localhost:3000/workflow`

- [ ] **Step 1:** Navigate to Workflow page
- [ ] **Step 2:** Look for theme toggle icon in header toolbar
- [ ] **Step 3:** Verify icon is visible (Moon 🌙 in Light mode)
- [ ] **Step 4:** Verify icon is positioned after tab buttons, before "Back to Canvas" button

**Expected Result:**
- ✅ Moon icon visible in Light mode
- ✅ Icon is properly aligned in toolbar
- ✅ Icon has hover effect

---

### Test 7: Workflow Page - Theme Switch
**Page:** `http://localhost:3000/workflow`

- [ ] **Step 1:** Click the Moon icon
- [ ] **Step 2:** Verify icon changes to Sun (🌞)
- [ ] **Step 3:** Verify page switches to dark mode
- [ ] **Step 4:** Check console for log: `"Theme switched to Dark"`

**Expected Result:**
- ✅ Instant theme switch
- ✅ Dark mode applied
- ✅ Console log present

---

### Test 8: Theme Persistence - Page Refresh
**Page:** Any page

- [ ] **Step 1:** Switch to Dark mode on any page
- [ ] **Step 2:** Refresh the page (`Ctrl + R` or `F5`)
- [ ] **Step 3:** Verify page loads in Dark mode (no flash of light theme)
- [ ] **Step 4:** Verify Sun icon is visible
- [ ] **Step 5:** Switch to Light mode
- [ ] **Step 6:** Refresh the page
- [ ] **Step 7:** Verify page loads in Light mode
- [ ] **Step 8:** Verify Moon icon is visible

**Expected Result:**
- ✅ No flash of wrong theme (FOUC)
- ✅ Theme persists across refreshes
- ✅ Correct icon displayed on load

---

### Test 9: Theme Persistence - Page Navigation
**Page:** All pages

- [ ] **Step 1:** Switch to Dark mode on Dashboard
- [ ] **Step 2:** Navigate to Canvas page
- [ ] **Step 3:** Verify Canvas page is in Dark mode
- [ ] **Step 4:** Navigate to Workflow page
- [ ] **Step 5:** Verify Workflow page is in Dark mode
- [ ] **Step 6:** Navigate back to Dashboard
- [ ] **Step 7:** Verify Dashboard is still in Dark mode

**Expected Result:**
- ✅ Theme persists across all pages
- ✅ No theme reset when navigating

---

### Test 10: localStorage Verification
**Page:** Any page

- [ ] **Step 1:** Open Browser Console (`F12`)
- [ ] **Step 2:** Go to Application tab → Local Storage → `http://localhost:3000`
- [ ] **Step 3:** Look for key: `floneo-theme`
- [ ] **Step 4:** Verify value is `"light"` or `"dark"`
- [ ] **Step 5:** Switch theme
- [ ] **Step 6:** Verify localStorage value updates immediately

**Expected Result:**
- ✅ `floneo-theme` key exists in localStorage
- ✅ Value is either `"light"` or `"dark"`
- ✅ Value updates when theme switches

---

### Test 11: No Regression - Existing Functionality
**Page:** All pages

- [ ] **Step 1:** Verify all existing buttons still work (Save, Logout, etc.)
- [ ] **Step 2:** Verify no layout shifts or broken elements
- [ ] **Step 3:** Verify no console errors (except expected warnings)
- [ ] **Step 4:** Verify all text is readable in both themes
- [ ] **Step 5:** Verify all interactive elements are clickable

**Expected Result:**
- ✅ No existing functionality broken
- ✅ No layout issues
- ✅ No console errors
- ✅ All elements accessible

---

### Test 12: Keyboard Accessibility
**Page:** Any page

- [ ] **Step 1:** Use `Tab` key to navigate to theme toggle
- [ ] **Step 2:** Verify toggle button receives focus (visible outline)
- [ ] **Step 3:** Press `Enter` or `Space` to activate toggle
- [ ] **Step 4:** Verify theme switches

**Expected Result:**
- ✅ Toggle is keyboard accessible
- ✅ Focus indicator visible
- ✅ Enter/Space activates toggle

---

### Test 13: Mobile Responsiveness (Optional)
**Page:** All pages

- [ ] **Step 1:** Open Browser DevTools (`F12`)
- [ ] **Step 2:** Toggle device toolbar (mobile view)
- [ ] **Step 3:** Verify theme toggle is visible on mobile
- [ ] **Step 4:** Verify toggle is clickable on mobile
- [ ] **Step 5:** Verify theme switches work on mobile

**Expected Result:**
- ✅ Toggle visible on mobile
- ✅ Toggle clickable on mobile
- ✅ Theme switches work on mobile

---

### Test 14: Multiple Tabs Sync (Optional)
**Page:** Any page

- [ ] **Step 1:** Open Dashboard in two browser tabs
- [ ] **Step 2:** Switch theme in Tab 1
- [ ] **Step 3:** Refresh Tab 2
- [ ] **Step 4:** Verify Tab 2 shows the new theme

**Expected Result:**
- ✅ Theme persists across tabs (after refresh)

---

## 🐛 Bug Reporting Template

If you find any issues, please report using this template:

```
**Bug Title:** [Brief description]

**Page:** [Dashboard / Canvas / Workflow]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Result:**
[What should happen]

**Actual Result:**
[What actually happened]

**Console Errors:**
[Any errors in browser console]

**Screenshots:**
[If applicable]

**Browser:**
[Chrome / Firefox / Safari / Edge]

**Theme:**
[Light / Dark]
```

---

## ✅ Sign-Off Checklist

After completing all tests:

- [ ] All 14 test cases passed
- [ ] No console errors found
- [ ] No layout issues found
- [ ] No existing functionality broken
- [ ] Theme persists correctly
- [ ] All three pages tested (Dashboard, Canvas, Workflow)
- [ ] Both themes tested (Light and Dark)
- [ ] localStorage verified
- [ ] Console logging verified

**Tester Name:** ___________________  
**Date:** ___________________  
**Status:** [ ] PASS  [ ] FAIL  

---

## 🎉 Expected Final State

After all tests pass:

✅ **Dashboard Page:**
- Theme toggle visible in top-right header
- Switches between Light/Dark instantly
- Theme persists across refreshes

✅ **Canvas Page:**
- Theme toggle visible in header toolbar
- Switches between Light/Dark instantly
- Theme persists across refreshes

✅ **Workflow Page:**
- Theme toggle visible in header toolbar
- Switches between Light/Dark instantly
- Theme persists across refreshes

✅ **Global:**
- Theme persists across all pages
- localStorage stores preference
- Console logs theme switches
- No existing functionality broken
- No layout issues
- Keyboard accessible

---

**Ready for Production!** 🚀


