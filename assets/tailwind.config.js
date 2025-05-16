module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/pescarte_web.ex",
    "../lib/pescarte_web/**/*.*ex",
  ],
  theme: {
    // Updated color scheme to match Figma design system
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      
      // Neutral colors (renamed from black to neutral for semantic naming)
      neutral: {
        100: "#101010",
        80: "#404040",
        60: "#707070",
        40: "#9F9F9F",
        20: "#CFCFCF",
        5: "#F5F5F5",
      },
      
      // White (kept for backward compatibility)
      white: {
        100: "#FFFFFF",
        80: "#FCFCFC",
        60: "#F9F9F9",
      },
      
      // Primary color (blue)
      primary: {
        100: "#0064C8",
        80: "#3383D3",
        60: "#66A1DF",
        40: "#99C0EA",
        20: "#CCDFF4",
        5: "#F2F7FC",
      },
      
      // Secondary color (orange)
      secondary: {
        100: "#FF6E00", // Fixed from incorrect #FFE600
        80: "#FF8B33",
        60: "#FFA866",
        40: "#FFC699",
        20: "#FFE2CC",
        5: "#FFF7F0",
      },
      
      // Support colors (semantic)
      success: "#00BA88",
      warning: "#F1C21B",
      error: "#FA4D56",
      info: "#4589FF",
      
      // Legacy color naming for backward compatibility
      // (Gradually phase these out in favor of the semantic naming above)
      blue: {
        100: "#0064C8",
        80: "#3383D3",
        60: "#66A1DF",
        40: "#99C0EA",
        20: "#CCDFF4",
        10: "#E5EFF9",
        5: "#F2F7FC",
      },
      orange: {
        100: "#FF6E00",
        80: "#FF8B33",
        60: "#FFA866",
        40: "#FFC699",
        20: "#FFE2CC",
        10: "#FFF0E5",
        5: "#FFF7F0",
      },
      black: {
        100: "#101010",
        80: "#404040",
        60: "#707070",
        40: "#9F9F9F",
        20: "#CFCFCF",
        10: "#E7E7E7",
        5: "#F5F5F5",
      },
    },
    
    // Grid units based on design system
    spacing: {
      0: '0',
      0.5: '4px', // Square grid unit
      1: '8px',   // Spacing unit (2x square grid)
      2: '16px',  // 2x spacing unit
      3: '24px',  // 3x spacing unit
      4: '32px',  // 4x spacing unit
      5: '40px',  // 5x spacing unit
      6: '48px',  // 6x spacing unit
      8: '64px',  // 8x spacing unit
      10: '80px', // 10x spacing unit
      12: '96px', // 12x spacing unit
      16: '128px', // 16x spacing unit
      20: '160px', // 20x spacing unit
      24: '192px', // 24x spacing unit
      32: '256px', // 32x spacing unit
    },
    
    // Updated line heights to match design system
    lineHeight: {
      none: '1',
      tight: '1.15', // h1 ratio
      normal: '1.25', // h2-h3 ratio
      relaxed: '1.5', // body ratio
      // Legacy numeric values for backward compatibility
      10: "46px", // h1
      8: "38px",  // h2
      7: "28px",  // h3
      6: "24px",  // h4
      5: "22px",  // body-large
      4: "20px",  // body
      3: "18px",  // small
    },
    
    // Typography size scale
    fontSize: {
      xs: "12px",    // Small caption
      sm: "14px",    // Small body
      base: "16px",  // Body
      lg: "18px",    // Large body
      xl: "20px",    // h5/h4
      "2xl": "24px", // h3
      "3xl": "32px", // h2
      "4xl": "40px", // h1
    },
    
    // Font weights from design system
    fontWeight: {
      normal: '400',
      medium: '500',
      bold: '700',
    },
    
    // Font families
    fontFamily: {
      sans: ["Work Sans", "sans-serif"],
      secondary: ["Inter", "sans-serif"],
    },
    
    // Grid system
    gridTemplateColumns: {
      // 12-column grid
      12: 'repeat(12, minmax(0, 1fr))',
      // Container with explicit gutters
      'container': 'repeat(12, minmax(0, 1fr))',
    },
    
    // Container configuration
    container: {
      center: true,
      padding: {
        DEFAULT: '8px',  // 1x spacing unit
        sm: '16px',      // 2x spacing unit
        md: '24px',      // 3x spacing unit
        lg: '32px',      // 4x spacing unit
        xl: '40px',      // 5x spacing unit
      },
    },
    
    extend: {
      borderWidth: { 1: "1.5px" },
      borderRadius: {
        'sm': '4px',
        DEFAULT: '8px',
        'md': '12px',
        'lg': '16px',
        'xl': '24px',
      },
    },
  },
  
  // Plugins
  plugins: [
    require("@tailwindcss/forms"),
    // Custom plugin for grid layout
    function({ addComponents }) {
      addComponents({
        '.container-grid': {
          display: 'grid',
          gridTemplateColumns: 'repeat(12, minmax(0, 1fr))',
          gap: '16px', // 2x spacing unit
        }
      })
    }
  ],
  
  future: {
    // Preparing for Tailwind CSS v4 which uses standard CSS features
    hoverOnlyWhenSupported: true,
    respectDefaultRingColorOpacity: true,
    disableColorOpacityUtilitiesByDefault: true,
  },
};
