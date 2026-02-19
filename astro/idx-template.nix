{pkgs, template ? "basics", version ? "latest", packageManager ? "npm", typescript ? "strict", git ? true, tailwind ? false, ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.nodePackages.pnpm
    pkgs.bun
    pkgs.j2cli
    pkgs.nixfmt
  ];

  bootstrap = ''
    mkdir "$out"
    ${
      if packageManager == "npm" then "npm create astro@${version} \\\"$out\\\" -- --template ${template} --typescript ${typescript} ${if git then \\\"--git\\\" else \\\"--no-git\\\" } --no-install"
      else if packageManager == "yarn" then "yarn create astro \\\"$out\\\" --template ${template} --typescript ${typescript} ${if git then \\\"--git\\\" else \\\"--no-git\\\" } --no-install" 
      else if packageManager == "pnpm" then "pnpm create astro \\\"$out\\\" --template ${template} --typescript ${typescript} ${if git then \\\"--git\\\" else \\\"--no-git\\\" } --no-install"
      else if packageManager == "bun" then "bun create astro \\\"$out\\\" --template ${template} --typescript ${typescript} ${if git then \\\"--git\\\" else \\\"--no-git\\\" } --no-install"
      else "npm create astro@${version} \\\"$out\\\" -- --template ${template} --typescript ${typescript} ${if git then \\\"--git\\\" else \\\"--no-git\\\" } --no-install"
    }

    mkdir -p "$out"/.idx
    packageManager=${packageManager} tailwind=${if tailwind then "true" else "false"} j2 ${./devNix.j2} -o "$out"/.idx/dev.nix
    nixfmt "$out"/.idx/dev.nix

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out"/.idx/airules.md"
    cp -rf "$out"/.idx/airules.md" "$out/GEMINI.md"
    
    # Create eslint config
    cat <<EOF > "$out/eslint.config.js"
module.exports = [
  "eslint:recommended",
  ...require("@typescript-eslint/eslint-plugin").configs.recommended,
  ...require("eslint-plugin-astro").configs.recommended,
  "prettier",
];
EOF

    # Create prettier config
    cat <<EOF > "$out/.prettierrc"
{
  "plugins": ["prettier-plugin-astro"],
  "overrides": [
    {
      "files": "*.astro",
      "options": {
        "parser": "astro"
      }
    }
  ]
}
EOF

    # Create prettier ignore
    cat <<EOF > "$out/.prettierignore"
dist
.astro
EOF
    
    chmod -R u+w "$out"

    (
      cd "$out" && \
      node -e "
const fs = require('fs');
const path = require('path');
const packageJsonPath = path.join(process.cwd(), 'package.json');
console.log('Updating package.json at:', packageJsonPath);
if (fs.existsSync(packageJsonPath)) {
  console.log('package.json found. Updating...');
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf-8'));

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
    'prettier-plugin-astro': 'latest'
  };

  fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
  console.log('package.json updated successfully.');
} else {
  console.log('package.json not found at:', packageJsonPath);
}
"
    )
    
    ${if packageManager == "npm" then "( cd \\$out && npm i --package-lock-only --ignore-scripts )" else ""}
  '';
}

