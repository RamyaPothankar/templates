import eslintPluginAstro from 'eslint-plugin-astro';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';

export default [
  // 1. Global ignores
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },

  // 2. Recommended rules from typescript-eslint, applied to all .ts files
  ...tseslint.configs.recommended,

  // 3. Astro rules
  ...eslintPluginAstro.configs.all,

  // 4. Prettier config must be last.
  prettier,
];
