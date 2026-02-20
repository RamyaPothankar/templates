import fs from 'node:fs';
import path from 'node:path';

const packageJsonPath = path.join(process.cwd(), 'package.json');

const scriptsToAdd = {
  lint: 'eslint .',
  'lint:fix': 'eslint . --fix',
  format: 'prettier --check .',
  'format:fix': 'prettier --write .'
};

const devDependenciesToAdd = {
  '@eslint/js': 'latest',
  'typescript-eslint': 'latest',
  'eslint': '^8.0.0',
  'eslint-plugin-astro': 'latest',
  'eslint-config-prettier': 'latest',
  'prettier': 'latest',
  'prettier-plugin-astro': 'latest'
};

const prettierConfig = {
  "plugins": ["prettier-plugin-astro"],
  "overrides": [
    {
      "files": "*.astro",
      "options": {
        "parser": "astro"
      }
    }
  ]
};

try {
  const packageJsonContent = fs.readFileSync(packageJsonPath, 'utf8');
  const packageJson = JSON.parse(packageJsonContent);

  packageJson.scripts = { ...packageJson.scripts, ...scriptsToAdd };

  packageJson.devDependencies = {
    ...packageJson.devDependencies,
    ...devDependenciesToAdd,
  };

  packageJson.prettier = prettierConfig;

  const updatedPackageJsonContent = JSON.stringify(packageJson, null, 2);
  fs.writeFileSync(packageJsonPath, updatedPackageJsonContent);

  console.log('Successfully updated package.json with ESLint and Prettier!');
} catch (error) {
  console.error('Error updating package.json:', error);
  process.exit(1);
}

