const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    '../lib/*_web/**/*.sface'
  ],
  theme: {
    colors: {
      blue: {
        100: '#BCE0EF',
        300: '#88B8CC',
        500: '#277DA1',
        700: '#0E4771'
      },
      green: '#25CE52',
      orange: '#F8961E',
      yellow: '#F5BD00',
      red: '#FF635D',
      white: colors.white,
      black: colors.black
    },
    fontFamily: {
      sans: ['Open Sans', 'sans-serif']
    },
    container: {
      center: true
    },
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require("daisyui")
  ]
}
