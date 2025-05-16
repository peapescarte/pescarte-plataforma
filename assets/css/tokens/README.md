# Design Tokens

This directory is for reference only. The true source of truth for all design tokens (colors, typography, spacing, etc.) is in the Tailwind configuration file (`tailwind.config.js`).

## Usage

When creating CSS, use Tailwind utility classes directly or via the `@apply` directive:

```css
.my-component {
  @apply text-primary-100 bg-neutral-5 p-4 rounded-md;
}
```

## Tokens Reference

For quick reference, here are the design tokens defined in the Tailwind config:

### Colors

- **Neutral:** neutral-100, neutral-80, neutral-60, neutral-40, neutral-20, neutral-5
- **White:** white-100, white-80, white-60
- **Primary (Blue):** primary-100, primary-80, primary-60, primary-40, primary-20, primary-5
- **Secondary (Orange):** secondary-100, secondary-80, secondary-60, secondary-40, secondary-20, secondary-5
- **Support Colors:** success, warning, error, info

### Typography

- **Font Families:**

  - Primary: "Work Sans", sans-serif
  - Secondary: "Inter", sans-serif

- **Font Sizes:**

  - xs: 12px (Small caption)
  - sm: 14px (Small body)
  - base: 16px (Body)
  - lg: 18px (Large body)
  - xl: 20px (h5/h4)
  - 2xl: 24px (h3)
  - 3xl: 32px (h2)
  - 4xl: 40px (h1)

- **Font Weights:**

  - normal: 400
  - medium: 500
  - bold: 700

- **Line Heights:**
  - none: 1
  - tight: 1.15 (h1 ratio)
  - normal: 1.25 (h2-h3 ratio)
  - relaxed: 1.5 (body ratio)

### Spacing

Based on 8px scale (--spacing-unit):

- 0.5: 4px (Square grid unit)
- 1: 8px (Spacing unit)
- 2: 16px (2x spacing unit)
- 3: 24px (3x spacing unit)
- 4: 32px (4x spacing unit)
- etc.

### Grid

- 12-column grid system
- Container with explicit gutters (16px)

### Border Radius

- sm: 4px
- DEFAULT: 8px
- md: 12px
- lg: 16px
- xl: 24px
