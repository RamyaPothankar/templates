import tseslint from 'typescript-eslint';
import angularEslint from '@angular-eslint/eslint-plugin';
import prettier from 'eslint-config-prettier';
import angularTemplateParser from '@angular-eslint/template-parser';

export default [
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },
  ...tseslint.configs.recommended,

  // Angular component templates
  {
    files: ['src/**/*.html'],
    plugins: {
      '@angular-eslint': angularEslint,
    },
    languageOptions: {
      parser: angularTemplateParser,
    },
    rules: angularEslint.configs.template_recommended.rules,
  },

  // Angular typescript files
  {
    files: ['src/**/*.ts'],
    plugins: {
      '@angular-eslint': angularEslint,
    },
    rules: angularEslint.configs.recommended.rules,
  },

  prettier,
];
