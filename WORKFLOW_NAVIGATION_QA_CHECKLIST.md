# Workflow Navigation QA Checklist

## 🎯 Purpose
This checklist verifies that workflow-based navigation works correctly for ALL element types in the Floneo dashboard runtime.

---

## ✅ Pre-Test Setup

### 1. Environment Check
- [ ] Docker containers running: `docker ps`
- [ ] Frontend accessible at http://localhost:3000
- [ ] Backend accessible at http://localhost:5000
- [ ] Browser cache cleared (`Ctrl + Shift + R`)
- [ ] DevTools Console open (F12)

### 2. Test App Setup
- [ ] Create test app with at least 3 pages (page-1, page-2, page-3)
- [ ] Add various element types to each page
- [ ] Create workflows for navigation testing

---

## 🧪 Test Matrix

### Test 1: Button Navigation (Baseline)

**Setup:**
- Page 1: Button with text "Go to Page 2"
- Workflow: onClick → page.redirect → targetPageId: "page-2"

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Verify button renders correctly
3. [ ] Click button
4. [ ] Verify navigation to page-2
5. [ ] Check console logs:
   - [ ] `[EVENT] button-id click`
   - [ ] `[WF-RUN] Starting workflow`
   - [ ] `[NAV] to page-2`

**Expected Result:** ✅ Navigation works

---

### Test 2: Shape/Container Navigation

**Setup:**
- Page 1: Rectangle/Container with workflow
- Workflow: onClick → page.redirect → targetPageId: "page-2"

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Hover over shape
   - [ ] Verify cursor changes to pointer
3. [ ] Click shape
   - [ ] Verify navigation to page-2
4. [ ] Tab to shape (keyboard navigation)
   - [ ] Verify shape is focusable
   - [ ] Verify focus indicator appears
5. [ ] Press Enter while focused
   - [ ] Verify navigation works
6. [ ] Check console logs:
   - [ ] `[EVENT] shape-id click`
   - [ ] `[NAV] to page-2`

**Expected Result:** ✅ Shape is clickable and keyboard accessible

---

### Test 3: Text Element Navigation

**Setup:**
- Page 1: Text element "Click here to continue"
- Workflow: onClick → page.redirect → targetPageId: "page-2"

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Hover over text
   - [ ] Verify cursor changes to pointer
3. [ ] Click text
   - [ ] Verify navigation to page-2
4. [ ] Tab to text (keyboard navigation)
   - [ ] Verify text is focusable
5. [ ] Press Enter while focused
   - [ ] Verify navigation works

**Expected Result:** ✅ Text is clickable and keyboard accessible

---

### Test 4: Image Navigation

**Setup:**
- Page 1: Image element
- Workflow: onClick → page.redirect → targetPageId: "page-2"

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Hover over image
   - [ ] Verify cursor changes to pointer
3. [ ] Click image
   - [ ] Verify navigation to page-2
4. [ ] Tab to image (keyboard navigation)
   - [ ] Verify image is focusable
5. [ ] Press Enter while focused
   - [ ] Verify navigation works

**Expected Result:** ✅ Image is clickable and keyboard accessible

---

### Test 5: Icon Navigation

**Setup:**
- Page 1: Icon element
- Workflow: onClick → page.redirect → targetPageId: "page-2"

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Hover over icon
   - [ ] Verify cursor changes to pointer
3. [ ] Click icon
   - [ ] Verify navigation to page-2
4. [ ] Tab to icon (keyboard navigation)
   - [ ] Verify icon is focusable
5. [ ] Press Enter while focused
   - [ ] Verify navigation works

**Expected Result:** ✅ Icon is clickable and keyboard accessible

---

### Test 6: Go Back Navigation

**Setup:**
- Page 1: Button "Go to Page 2" → page.redirect → page-2
- Page 2: Button "Go Back" → page.goBack

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Click "Go to Page 2" button
   - [ ] Verify navigation to page-2
3. [ ] Click "Go Back" button
   - [ ] Verify navigation back to page-1
4. [ ] Check console logs:
   - [ ] `[NAV] to page-2`
   - [ ] `[NAV] back to page-1, stack=[]`

**Expected Result:** ✅ Go back navigation works

---

### Test 7: Multi-Level Navigation History

**Setup:**
- Page 1: Button → page-2
- Page 2: Button → page-3
- Page 3: Button → page.goBack

**Test Steps:**
1. [ ] Navigate to page-1
2. [ ] Click button → Navigate to page-2
3. [ ] Click button → Navigate to page-3
4. [ ] Click "Go Back" button
   - [ ] Verify navigation to page-2
5. [ ] Click "Go Back" button again
   - [ ] Verify navigation to page-1
6. [ ] Check console logs:
   - [ ] `[NAV] to page-2`
   - [ ] `[NAV] to page-3`
   - [ ] `[NAV] back to page-2, stack=['page-1']`
   - [ ] `[NAV] back to page-1, stack=[]`

**Expected Result:** ✅ Navigation stack maintains history correctly

---

### Test 8: Form Controls with Workflows

**Setup:**
- Page 1: Text field with onChange workflow → page.redirect → page-2
- Page 1: Checkbox with onClick workflow → page.redirect → page-3

**Test Steps:**

#### Text Field:
1. [ ] Click into text field
   - [ ] Verify field is focusable
   - [ ] Verify NO navigation occurs on click
2. [ ] Type text
   - [ ] Verify typing works normally
3. [ ] Change value and blur
   - [ ] Verify onChange workflow triggers
   - [ ] Verify navigation to page-2

#### Checkbox:
1. [ ] Click checkbox
   - [ ] Verify checkbox toggles
   - [ ] Verify workflow triggers
   - [ ] Verify navigation to page-3

**Expected Result:** ✅ Form controls preserve native behavior

---

### Test 9: Multi-Step Workflow with Connectors

**Setup:**
- Page 1: Button with workflow:
  - Node 1: onClick (Trigger)
  - Node 2: console.log "Step 1" (Action) → connected via "next"
  - Node 3: console.log "Step 2" (Action) → connected via "next"
  - Node 4: page.redirect → page-2 (Action) → connected via "next"

**Test Steps:**
1. [ ] Navigate to page-1
2. [ ] Click button
3. [ ] Check console logs:
   - [ ] `[WF-RUN] Starting workflow, nodes: 4`
   - [ ] `[WF-RUN] Step 0 : onClick`
   - [ ] `[WF-RUN] Step 1 : console.log`
   - [ ] `Step 1` (from console.log action)
   - [ ] `[WF-RUN] Step 2 : console.log`
   - [ ] `Step 2` (from console.log action)
   - [ ] `[WF-RUN] Step 3 : page.redirect`
   - [ ] `[NAV] to page-2`
4. [ ] Verify navigation to page-2

**Expected Result:** ✅ Workflow executes all steps in order

---

### Test 10: Conditional Navigation (Yes/No Connectors)

**Setup:**
- Page 1: Button with workflow:
  - Node 1: onClick (Trigger)
  - Node 2: condition.check (Condition)
  - Node 3a: page.redirect → page-2 (connected via "yes")
  - Node 3b: page.redirect → page-3 (connected via "no")

**Test Steps:**
1. [ ] Set condition to true
2. [ ] Click button
   - [ ] Verify navigation to page-2
3. [ ] Go back to page-1
4. [ ] Set condition to false
5. [ ] Click button
   - [ ] Verify navigation to page-3

**Expected Result:** ✅ Conditional navigation works

---

### Test 11: Error Handling (onError Connector)

**Setup:**
- Page 1: Button with workflow:
  - Node 1: onClick (Trigger)
  - Node 2: api.call (Action that might fail)
  - Node 3a: page.redirect → page-2 (connected via "next")
  - Node 3b: page.redirect → page-3 (connected via "onError")

**Test Steps:**
1. [ ] Configure API to succeed
2. [ ] Click button
   - [ ] Verify navigation to page-2
3. [ ] Go back to page-1
4. [ ] Configure API to fail
5. [ ] Click button
   - [ ] Verify navigation to page-3
6. [ ] Check console logs:
   - [ ] `[WF-RUN] Error at step X`

**Expected Result:** ✅ Error handling works

---

### Test 12: Multiple Workflows on Same Element

**Setup:**
- Page 1: Button with TWO workflows:
  - Workflow 1: onClick → console.log "Workflow 1"
  - Workflow 2: onClick → page.redirect → page-2

**Test Steps:**
1. [ ] Navigate to page-1
2. [ ] Click button
3. [ ] Check console logs:
   - [ ] `[EVENT] Found 2 workflow(s) for button-id:click`
   - [ ] `[EVENT] Executing workflow 1 of 2`
   - [ ] `Workflow 1` (from console.log)
   - [ ] `[EVENT] Executing workflow 2 of 2`
   - [ ] `[NAV] to page-2`
4. [ ] Verify navigation to page-2

**Expected Result:** ✅ Both workflows execute

---

### Test 13: URL Updates

**Setup:**
- Page 1: Button → page.redirect → page-2

**Test Steps:**
1. [ ] Navigate to `/run?appId=X&pageId=page-1`
2. [ ] Note the URL
3. [ ] Click button
4. [ ] Verify URL changes to `/run?appId=X&pageId=page-2`
5. [ ] Copy URL
6. [ ] Open in new tab
   - [ ] Verify page-2 loads directly

**Expected Result:** ✅ URLs are bookmarkable

---

### Test 14: No Workflow (Fallback Behavior)

**Setup:**
- Page 1: Button with NO workflow

**Test Steps:**
1. [ ] Navigate to page-1
2. [ ] Hover over button
   - [ ] Verify cursor is default (not pointer)
3. [ ] Click button
   - [ ] Verify no navigation occurs
4. [ ] Check console logs:
   - [ ] `[EVENT] button-id click`
   - [ ] `[EVENT] No workflows found for button-id:click`

**Expected Result:** ✅ Elements without workflows work normally

---

## 🔍 Console Log Verification

For each test, verify the following logs appear:

### Workflow Index Creation (on page load)
```
[WF-INDEX] Map(X) { 'element-1:click' => [...], ... }
```

### Event Firing
```
[EVENT] element-id event-type { data }
[EVENT] Found X workflow(s) for element-id:event-type
[EVENT] Executing workflow 1 of X
```

### Workflow Execution
```
[WF-RUN] Starting workflow, nodes: X
[WF-RUN] Step 0 : trigger-name
[WF-RUN] Step 1 : action-name
...
```

### Navigation
```
[NAV] to page-id
[NAV] back to page-id, stack=[...]
```

---

## 🐛 Common Issues & Troubleshooting

### Issue: Element not clickable
**Symptoms:** No pointer cursor, element doesn't respond to clicks
**Possible Causes:**
- Workflow not properly linked to element
- `hasClickWorkflow` function not passed to CanvasRenderer
- Element type not yet updated to support workflows
**Solution:** Check workflow index in console, verify element ID matches

### Issue: Navigation doesn't work
**Symptoms:** Click occurs but no page change
**Possible Causes:**
- Workflow missing `page.redirect` or `page.goBack` action
- Target page ID invalid
- Workflow execution stops before navigation action
**Solution:** Check console logs for workflow execution steps

### Issue: Keyboard navigation doesn't work
**Symptoms:** Can't tab to element, Enter doesn't trigger
**Possible Causes:**
- Element type not updated with `role="button"` and `tabIndex={0}`
- Browser focus management issue
**Solution:** Verify clickableProps applied to element

### Issue: Form controls don't work
**Symptoms:** Can't type in text field, checkbox doesn't toggle
**Possible Causes:**
- `preventDefault` called on input events
- Workflow triggering on wrong event (click instead of change)
**Solution:** Verify native input behavior preserved

### Issue: Console logs missing
**Symptoms:** No `[WF-INDEX]`, `[EVENT]`, or `[NAV]` logs
**Possible Causes:**
- Browser cache not cleared
- Old frontend version running
- Console filter active
**Solution:** Hard refresh (`Ctrl + Shift + R`), check console filters

---

## ✅ Sign-Off

### Tester Information
- **Name:** ___________________________
- **Date:** ___________________________
- **Environment:** ___________________________

### Test Results Summary
- **Total Tests:** 14
- **Passed:** _____ / 14
- **Failed:** _____ / 14
- **Blocked:** _____ / 14

### Notes
_______________________________________________________
_______________________________________________________
_______________________________________________________

### Approval
- [ ] All critical tests passed
- [ ] Known issues documented
- [ ] Ready for production

**Signature:** ___________________________

