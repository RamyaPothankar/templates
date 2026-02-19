const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(process.cwd(), 'package.json');
const packageJson = require(packageJsonPath);

packageJson.scripts = {
  ...packageJson.scripts,
  'lint': 'eslint .'
};

packageJson.devDependencies = {
  ...packageJson.devDependencies,
  '@typescript-eslint/parser': 'latest',
  '@typescript-eslint/eslint-plugin': 'latest',
  'eslint': '^8.0.0',
  'eslint-plugin-astro': 'latest',
  'eslint-config-prettier': 'latest',
  'prettier': 'latest',
  'prettier-plugin-astro': 'latest',
};

fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
