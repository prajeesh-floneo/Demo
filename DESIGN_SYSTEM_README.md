# 🎨 Floneo Design System

## Overview

The Floneo Design System is a comprehensive, unified styling system that provides a single source of truth for all colors, tokens, and theme variables across the entire platform.

**File:** `client/styles/design-system.css`

---

## 🌈 Brand Colors

### Light Theme
- **Blue** (`--brand-blue`): `#0066FF` - Primary brand color
- **Pink** (`--brand-pink`): `#FF4FCB` - Secondary brand color
- **Green** (`--brand-green`): `#2ECC71` - Success states
- **Yellow** (`--brand-yellow`): `#FFC107` - Warning states

### Dark Theme
- **Blue** (`--brand-blue`): `#4D8DFF` - Brighter for dark backgrounds
- **Pink** (`--brand-pink`): `#FF74DA` - Brighter for dark backgrounds
- **Green** (`--brand-green`): `#45DB9A` - Brighter for dark backgrounds
- **Yellow** (`--brand-yellow`): `#FFD250` - Brighter for dark backgrounds

---

## 🎭 Theme System

The design system uses the `data-theme` attribute on the `<html>` element to switch between light and dark themes.

### How It Works

1. **Initialization**: An inline script in `layout.tsx` runs before React hydrates
2. **Detection**: Checks `localStorage` for saved theme, falls back to system preference
3. **Application**: Sets `data-theme="light"` or `data-theme="dark"` on `<html>`
4. **Persistence**: Theme choice is saved to `localStorage` with key `floneo-theme`

### Theme Switching

```tsx
import { useTheme } from "@/hooks/use-theme";

function MyComponent() {
  const { theme, setTheme } = useTheme();
  
  return (
    <button onClick={() => setTheme(theme === "light" ? "dark" : "light")}>
      Toggle Theme
    </button>
  );
}
```

### Console Logging

The theme system logs to the console for debugging:
- `[THEME] Initialized with theme: light` - On page load
- `[THEME] Theme switched to Dark` - When toggling to dark
- `[THEME] Theme switched to Light` - When toggling to light

---

## 🎨 Design Tokens

### Neutrals (Light Theme)
- `--bg-0`: `#ffffff` - Pure white
- `--bg-1`: `#F7F8FA` - Light gray
- `--bg-2`: `#EDF0F5` - Lighter gray
- `--text-1`: `#0F1222` - Primary text (dark)
- `--text-2`: `#42465A` - Secondary text (muted)
- `--border-1`: `#E3E6ED` - Border color

### Neutrals (Dark Theme)
- `--bg-0`: `#0D0F16` - Deep navy/ink (NOT pure black)
- `--bg-1`: `#121522` - Slightly lighter navy
- `--bg-2`: `#171A2A` - Even lighter navy
- `--text-1`: `#E9ECF8` - Primary text (light)
- `--text-2`: `#ABB1C6` - Secondary text (muted)
- `--border-1`: `#24283A` - Border color

### Surfaces
- `--app-bg`: Background gradient for the entire app
  - Light: `linear-gradient(180deg, #F8FBFF 0%, #F2F5FA 100%)`
  - Dark: `radial-gradient(1200px 800px at 70% 0%, #151A2B 0%, #0D0F16 65%)`
- `--surface`: Base surface color (white in light, navy in dark)
- `--panel`: Panel background with subtle brand tint
- `--panel-glass`: Glassmorphism panel background

### Accents & Semantic
- `--accent`: Primary accent color (brand blue)
- `--accent-2`: Secondary accent color (brand pink)
- `--success`: Success state color (brand green)
- `--warn`: Warning state color (brand yellow)
- `--danger`: Danger/error state color (red)

### Radius
- `--radius-xs`: `6px` - Extra small radius
- `--radius-sm`: `10px` - Small radius (buttons, inputs)
- `--radius-md`: `14px` - Medium radius (panels, cards)
- `--radius-lg`: `20px` - Large radius

### Shadows
- `--shadow-1`: `0 4px 16px rgba(3, 10, 28, 0.08)` - Light shadow
- `--shadow-2`: `0 10px 30px rgba(3, 10, 28, 0.22)` - Heavy shadow
- `--shadow`: Theme-aware shadow (light in light theme, heavy in dark theme)

### Glass Effects
- `--glass-bg`: `rgba(255, 255, 255, 0.55)` - Light glass background
- `--glass-bg-dark`: `rgba(18, 21, 34, 0.55)` - Dark glass background
- `--glass-blur`: `14px` - Backdrop blur amount

### Focus
- `--focus-outline`: `3px solid var(--accent)` - Focus outline
- `--ring`: `0 0 0 3px color-mix(...)` - Focus ring with transparency

---

## 🧩 Utility Classes

### Layout Backgrounds

#### `.app-bg`
Applies the app background gradient.

```tsx
<div className="app-bg">
  {/* Your app content */}
</div>
```

#### `.surface`
Applies the base surface color.

```tsx
<div className="surface">
  {/* Content on surface */}
</div>
```

#### `.panel`
Creates a panel with border, shadow, and rounded corners.

```tsx
<div className="panel">
  {/* Panel content */}
</div>
```

#### `.panel--glass`
Creates a glassmorphism panel with backdrop blur.

```tsx
<div className="panel panel--glass">
  {/* Glass panel content */}
</div>
```

---

### Text Utilities

#### `.text-1`
Primary text color.

```tsx
<p className="text-1">Primary text</p>
```

#### `.text-2`
Secondary/muted text color.

```tsx
<p className="text-2">Secondary text</p>
```

#### `.link`
Link color (accent).

```tsx
<a href="#" className="link">Link</a>
```

#### `.muted`
Muted text color (same as `.text-2`).

```tsx
<span className="muted">Muted text</span>
```

---

### Buttons

#### `.btn`
Primary button with brand-blue background.

```tsx
<button className="btn">Save</button>
```

**Features:**
- Brand-blue background
- White text
- Rounded corners (`--radius-sm`)
- Shadow
- Hover: Lifts up 1px, slightly brighter
- Focus: Blue glow ring

#### `.btn--ghost`
Ghost button with transparent background and border.

```tsx
<button className="btn btn--ghost">Cancel</button>
```

**Features:**
- Transparent background
- Border
- Hover: Subtle background tint

---

### Inputs

#### `.input`
Text input field.

```tsx
<input type="text" className="input" placeholder="Enter text..." />
```

#### `.select`
Select dropdown.

```tsx
<select className="select">
  <option>Option 1</option>
  <option>Option 2</option>
</select>
```

#### `.textarea`
Textarea field.

```tsx
<textarea className="textarea" placeholder="Enter text..."></textarea>
```

**Features (all inputs):**
- Surface background
- Border
- Rounded corners (`--radius-sm`)
- Focus: Blue border + glow ring
- Placeholder: Muted color

---

### Tabs

#### `.tab`
Inactive tab.

```tsx
<button className="tab">Tab 1</button>
```

#### `.tab--active`
Active tab.

```tsx
<button className="tab tab--active">Tab 2</button>
```

**Features:**
- Pill shape (999px radius)
- Inactive: Subtle background
- Active: Brand-colored border + background tint
- Hover: Border color changes

---

### Additional Components

#### `.card`
Card component with border, shadow, and padding.

```tsx
<div className="card">
  <h3>Card Title</h3>
  <p>Card content</p>
</div>
```

#### `.divider`
Horizontal divider line.

```tsx
<hr className="divider" />
```

#### `.badge`
Badge/chip component.

```tsx
<span className="badge">Default</span>
<span className="badge badge--success">Success</span>
<span className="badge badge--warn">Warning</span>
<span className="badge badge--danger">Error</span>
```

#### `.custom-scrollbar`
Custom styled scrollbar.

```tsx
<div className="custom-scrollbar" style={{ overflowY: 'auto', height: '300px' }}>
  {/* Scrollable content */}
</div>
```

---

## 🚀 How to Use

### 1. Use Utility Classes (Recommended)

```tsx
<div className="panel">
  <h2 className="text-1">Title</h2>
  <p className="text-2">Description</p>
  <button className="btn">Save</button>
  <button className="btn btn--ghost">Cancel</button>
</div>
```

### 2. Use CSS Variables

```tsx
<div style={{
  background: 'var(--surface)',
  color: 'var(--text-1)',
  borderRadius: 'var(--radius-md)',
  padding: '16px',
  boxShadow: 'var(--shadow)'
}}>
  Custom component
</div>
```

### 3. Use in CSS/SCSS

```css
.my-component {
  background: var(--surface);
  color: var(--text-1);
  border: 1px solid var(--border-1);
  border-radius: var(--radius-md);
}

.my-component:hover {
  background: var(--panel);
}
```

---

## 📏 Best Practices

### ✅ DO

- **Use utility classes** whenever possible
- **Use CSS variables** for custom styles
- **Test in both themes** (light and dark)
- **Use semantic tokens** (`--accent`, `--success`, etc.) instead of brand colors directly
- **Respect the design system** - don't hardcode colors

### ❌ DON'T

- **Don't hardcode colors** - Always use CSS variables
- **Don't use pure black** in dark theme - Use `--bg-0`, `--bg-1`, etc.
- **Don't override theme variables** - Extend the design system instead
- **Don't use inline styles** for colors - Use utility classes or CSS variables

---

## 🔧 Extending the Design System

### Adding New Colors

Edit `client/styles/design-system.css`:

```css
:root[data-theme="light"] {
  /* Existing colors... */
  --my-new-color: #FF5733;
}

:root[data-theme="dark"] {
  /* Existing colors... */
  --my-new-color: #FF8A65;
}
```

### Adding New Utility Classes

Edit `client/styles/design-system.css`:

```css
.my-utility {
  background: var(--my-new-color);
  color: var(--text-1);
  padding: 12px;
  border-radius: var(--radius-sm);
}
```

### Adding New Tokens

Edit `client/styles/design-system.css`:

```css
:root {
  /* Existing tokens... */
  --my-new-radius: 18px;
  --my-new-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}
```

---

## 🧪 Testing

### Quick Test

1. Navigate to `http://localhost:3000`
2. Open DevTools Console
3. Look for: `[THEME] Initialized with theme: light`
4. Click theme toggle (🌙/🌞)
5. Look for: `[THEME] Theme switched to Dark`
6. Verify all colors change instantly
7. Refresh - theme should persist

### Comprehensive Test

Follow the **`DESIGN_SYSTEM_QA_CHECKLIST.md`** for 26 detailed test cases.

---

## 📚 Related Files

- **`client/styles/design-system.css`** - The design system itself
- **`client/app/layout.tsx`** - Root layout with theme initialization
- **`client/hooks/use-theme.ts`** - Theme hook for React components
- **`client/app/globals.css`** - Global styles with Tailwind integration
- **`DESIGN_SYSTEM_IMPLEMENTATION_SUMMARY.md`** - Implementation details
- **`DESIGN_SYSTEM_QA_CHECKLIST.md`** - Testing checklist

---

## 🎊 Summary

The Floneo Design System provides:

✅ **Single source of truth** for all colors and tokens  
✅ **Reliable theme switching** via `data-theme` attribute  
✅ **Brand-consistent colors** across light and dark themes  
✅ **Modern dark theme** with deep navy (not pure black)  
✅ **Utility classes** for rapid development  
✅ **Glassmorphism support** with backdrop blur  
✅ **Focus accessibility** with visible focus rings  
✅ **Console logging** for debugging  

**Ready to use!** Start building with the design system today. 🚀

