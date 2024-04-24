const path  = require('path');
const esbuild = require('esbuild');
const { sassPlugin } = require('esbuild-sass-plugin');
const postcss = require('postcss');
const autoprefixer = require('autoprefixer');
const tailwindcss = require('tailwindcss');

const args = process.argv.slice(2);
const watch = args.includes('--watch');
const deploy = args.includes('--deploy');

const loader = {};

const plugins = [
  sassPlugin({
  	async transform(source, resolveDir) {
  		const { css } = await postcss(
  			autoprefixer,
  			tailwindcss(path.resolve(__dirname, "./tailwind.config.js"))
  		).process(source, {from: undefined})
  		return css
  	}
  })
];

// Define esbuild options
let opts = {
  entryPoints: ["js/app.js"],
  bundle: true,
  logLevel: "info",
  target: "es2017",
  outdir: "../priv/static/assets",
  external: ["*.css", "/fonts/*", "/images/*"],
  nodePaths: ["../deps"],
  loader: loader,
  plugins: plugins,
};

if (deploy) {
  opts = {...opts, minify: true};
}

if (watch) {
  opts = {...opts, sourcemap: "inline"};

  esbuild
    .context(opts)
    .then((ctx) => {
      ctx.watch();
    })
    .catch((_error) => {
      process.exit(1);
    });
} else {
  esbuild.build(opts);
}
