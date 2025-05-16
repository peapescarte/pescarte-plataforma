module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/pescarte_web.ex",
    "../lib/pescarte_web/**/*.*ex"
  ],
  theme: {
    colors: {
      white: {
        100: "#fff",
        80: "#fafafa",
      },
      black: {
        100: "#101010",
        80: "#404040",
        60: "#707070",
        40: "#9f9f9f",
        20: "#cfcfcf",
        10: "#e7e7e7",
        5: "#f3f3f3",
      },
      blue: {
        100: "#0064c8",
        80: "#3383d3",
        60: "#66a2de",
        40: "#99c1e9",
        20: "#cce0f4",
        10: "#e5eff9",
        5: "#f2f7fc",
      },
      orange: {
        100: "#ff6e00",
        80: "#ff8b33",
        60: "#ffa866",
        40: "#ffc599",
        20: "#ffe2cc",
        10: "#fff0e5",
        5: "#fff8f2",
      },
      green: {
        100: "#00b464",
        80: "#33c383",
        60: "#66d2a2",
        40: "#99e1c1",
        20: "#ccf0e0",
        10: "#e5f7ef",
        5: "#f2fbf7",
      },
      yellow: {
        100: "#ffc832",
        80: "#ffd35b",
        60: "#ffde84",
        40: "#ffe9ad",
        20: "#fff4d6",
        10: "#fff9eb",
        5: "#fffcf5",
      },
      red: {
        100: "#fa3232",
        80: "#fb5b5b",
        60: "#fc8484",
        40: "#fdadad",
        20: "#fed6d6",
        10: "#ffebeb",
        5: "#fff5f5",
      },
    },
    lineHeight: {
      10: "46px",
      8: "38px",
      7: "28px",
      6: "24px",
      5: "22px",
      4: "20px",
      3: "18px",
    },
    fontSize: {
      sm: "12px",
      base: "14px",
      lg: "16px",
      xl: "20px",
      "2xl": "24px",
      "3xl": "32px",
      "4xl": "40px",
    },
    fontFamily: {
      sans: ["Work Sans", "sans-serif"],
    },
    container: {
      center: true,
    },
    extend: {
      borderWith: { 1: "1.5px" },
    },
  },
  plugins: [require('@tailwindcss/forms')]
};
