{ pkgs, ... }: {
  channel = "stable-24.11";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    npx --prefer-offline -y @angular/cli new --skip-git --defaults --skip-install --directory "$WS_NAME" "$WS_NAME"

    # --- Start of ADDED ESLint/Prettier Integration ---
    # Enter the new project directory to configure it.
    cd "$WS_NAME"

    # Create the .eslintrc.json config file
    cat <<'EOF' > .eslintrc.json
{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint", "prettier"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier"
  ],
  "rules": {
    "prettier/prettier": "error"
  }
}
EOF

    # Use Node.js to programmatically add scripts and dev dependencies to package.json
    node -e '
const fs = require("fs");
const pkgPath = "package.json";
const pkg = JSON.parse(fs.readFileSync(pkgPath, "utf-8"));

// Add linting and formatting scripts
pkg.scripts = {
  ...pkg.scripts,
  "lint": "eslint .",
  "format": "prettier --write ."
};

// Add new dev dependencies
pkg.devDependencies = {
  ...pkg.devDependencies,
  "eslint": "^8.57.0",
  "prettier": "^3.2.5",
  "@typescript-eslint/eslint-plugin": "^7.10.0",
  "@typescript-eslint/parser": "^7.10.0",
  "eslint-config-prettier": "^9.1.0",
  "eslint-plugin-prettier": "^5.1.3"
};

fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2));
'
    # --- End of ADDED ESLint/Prettier Integration ---

    # Now, go back to the original directory to finalize the template setup.
    cd ..

    mkdir "$WS_NAME"/.idx
    cp ${./dev.nix} "$WS_NAME"/.idx/dev.nix && chmod +w "$WS_NAME"/.idx/dev.nix
    mv "$WS_NAME" "$out"
    
    mkdir -p "$out/.idx"

    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"

    (cd "$out"; npm install --package-lock-only --ignore-scripts)
  '';
}


