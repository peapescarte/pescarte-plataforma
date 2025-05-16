module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/pescarte_web.ex",
    "../lib/pescarte_web/**/*.*ex",
  ],
  theme: {
    colors: {
      transparent: "transparent",
      current: "currentColor",

      neutral: {
        100: "#101010",
        80: "#404040",
        60: "#707070",
        40: "#9F9F9F",
        20: "#CFCFCF",
        5: "#F5F5F5",
      },

      white: {
        100: "#FFFFFF",
        80: "#FCFCFC",
        60: "#F9F9F9",
      },

      // Primary color (blue)
      primary: {
        100: "#0064C8",
        80: "#3383D3",
        60: "#66A2DE",
        40: "#99C1E9",
        20: "#CCE0F4",
        10: "#E5EFF9",
        5: "#F2F7FC",
      },

      // Secondary color (orange)
      secondary: {
        100: "#FF6E00",
        80: "#FF8B33",
        60: "#FFA866",
        40: "#FFC599",
        20: "#FFE2CC",
        10: "#FFF0E5",
        5: "#FFF8F2",
      },

      // Support colors (semantic)
      success: {
        100: "#00B464",
        80: "#33C383",
        60: "#66D2A2",
        40: "#99E1C1",
        20: "#CCF0E0",
        10: "#E5F7EF",
        5: "#F2FBF7",
      },
      warning: {
        100: "#FFC832",
        80: "#FFD35B",
        60: "#FFDE84",
        40: "#FFE9AD",
        20: "#FFF4D6",
        10: "#FFF9EB",
        5: "#FFFCF5",
      },
      error: {
        100: "#FA3232",
        80: "#FB5B5B",
        60: "#FC8484",
        40: "#FDADAD",
        20: "#FED6D6",
        10: "#FFEBEB",
        5: "#FFF5F5",
      },
    },

    // Grid units based on design system
    spacing: {
      0: "0",
      0.5: "4px", // Square grid unit
      1: "8px", // Spacing unit (2x square grid)
      2: "16px", // 2x spacing unit
      3: "24px", // 3x spacing unit
      4: "32px", // 4x spacing unit
      5: "40px", // 5x spacing unit
      6: "48px", // 6x spacing unit
      8: "64px", // 8x spacing unit
      10: "80px", // 10x spacing unit
      12: "96px", // 12x spacing unit
      16: "128px", // 16x spacing unit
      20: "160px", // 20x spacing unit
      24: "192px", // 24x spacing unit
      32: "256px", // 32x spacing unit
    },

    // Line heights from design system
    lineHeight: {
      none: "1",
      tight: "1.15", // H1 ratio (46px)
      normal: "1.19", // H2-H3 ratio (38px/28px)
      relaxed: "1.5", // Body ratio
      // Fixed values from Figma
      10: "46px", // H1 (40px font)
      8: "38px", // H2 (32px font)
      7: "28px", // H3 (24px font)
      6: "24px", // H4 (20px font)
      5: "22px", // H5/Body-large (18px font)
      4: "20px", // Body/Button (16px font)
      3: "18px", // Body Medium/Small (14px/12px font)
    },

    // Typography size scale from design system
    fontSize: {
      xs: "12px", // Body Small
      sm: "14px", // Body Medium
      base: "16px", // Body/Button
      lg: "18px", // H5 Headline
      xl: "20px", // H4 Headline
      "2xl": "24px", // H3 Headline
      "3xl": "32px", // H2 Headline
      "4xl": "40px", // H1 Headline
    },

    // Font weights from design system
    fontWeight: {
      normal: "400",
      medium: "500",
      bold: "700",
    },

    // Font families
    fontFamily: {
      sans: ["Work Sans", "sans-serif"],
      secondary: ["Inter", "sans-serif"],
    },

    // Grid system
    gridTemplateColumns: {
      // 12-column grid
      12: "repeat(12, minmax(0, 1fr))",
      // Container with explicit gutters
      container: "repeat(12, minmax(0, 1fr))",
    },

    // Container configuration
    container: {
      center: true,
      padding: {
        DEFAULT: "8px", // 1x spacing unit
        sm: "16px", // 2x spacing unit
        md: "24px", // 3x spacing unit
        lg: "32px", // 4x spacing unit
        xl: "40px", // 5x spacing unit
      },
    },

    extend: {
      borderWidth: { 1: "1.5px" },
      borderRadius: {
        sm: "4px",
        DEFAULT: "8px",
        md: "12px",
        lg: "16px",
        xl: "24px",
        full: "100px", // For pill-shaped buttons from Figma
      },
    },
  },

  // Plugins
  plugins: [
    require("@tailwindcss/forms"),
    // Custom plugin for grid layout
    function ({ addComponents }) {
      addComponents({
        ".container-grid": {
          display: "grid",
          gridTemplateColumns: "repeat(12, minmax(0, 1fr))",
          gap: "16px", // 2x spacing unit
        },
      });
    },
  ],

  future: {
    // Preparing for Tailwind CSS v4 which uses standard CSS features
    hoverOnlyWhenSupported: true,
    respectDefaultRingColorOpacity: true,
    disableColorOpacityUtilitiesByDefault: true,
  },
};
