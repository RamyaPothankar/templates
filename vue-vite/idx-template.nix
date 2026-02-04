{ pkgs, language ? "ts", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.nodePackages.eslint
    pkgs.nodePackages.prettier
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    npm create -y vite@latest "$WS_NAME" -- --template ${if language == "ts" then "vue-ts" else "vue"}
    mkdir -p "$WS_NAME/.idx/"
    cp -rf ${./icon.png} "$WS_NAME/.idx/icon.png"
    cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"
    
    cd "$out"; npm install --package-lock-only --ignore-scripts
    # ESLint and Prettier setup
    cat <<EOF > "$out/.eslintrc.json"
    {
      "root": true,
      "env": {
        "browser": true,
        "es2021": true,
        "node": true
      },
      "extends": [
        "eslint:recommended",
        "plugin:vue/vue3-essential",
        "prettier"
      ],
      "parserOptions": {
        "ecmaVersion": "latest",
        "parser": "@typescript-eslint/parser",
        "sourceType": "module"
      },
      "plugins": [
        "vue",
        "@typescript-eslint"
      ],
      "rules": {}
    }
    EOF

    cat <<EOF > "$out/.prettierrc.json"
    {
      "semi": false,
      "singleQuote": true
    }
    EOF

    # Update package.json
    jq '.scripts.lint = "eslint src --ext .vue,.js,.jsx,.cjs,.mjs,.ts,.tsx,.cts,.mts --fix --ignore-path .gitignore"' "$out/package.json" > "$out/package.json.tmp" && mv "$out/package.json.tmp" "$out/package.json"
    jq '.scripts.format = "prettier --write src"' "$out/package.json" > "$out/package.json.tmp" && mv "$out/package.json.tmp" "$out/package.json"
  '';
}
