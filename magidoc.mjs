import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

export default {
  introspection: {
    type: 'url',
    url: 'https://pescarte.uenf.br/api'
  },
  website: {
    template: 'carbon-multi-page',
    staticAssets: path.join(__dirname, 'assets'),
    options: {
      siteRoot: '/peapescarte/pescarte'
    }
  }
}
