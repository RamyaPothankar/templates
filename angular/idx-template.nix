{ pkgs, ... }: {
  channel = "stable-24.11";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    npx --prefer-offline -y @angular/cli new --skip-git --defaults --skip-install --directory "$WS_NAME" "$WS_NAME"
    cd "$WS_NAME"
    npm install eslint@8 prettier eslint-config-prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin @angular-eslint/eslint-plugin @angular-eslint/eslint-plugin-template @angular-eslint/template-parser --save-dev
    echo '{
      "root": true,
      "parser": "@typescript-eslint/parser",
      "plugins": [
        "@typescript-eslint"
      ],
      "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:@angular-eslint/recommended",
        "prettier"
      ],
      "rules": {}
    }' > .eslintrc.json
    node -e '
const fs = require("fs");
const pkg = JSON.parse(fs.readFileSync("package.json", "utf-8"));
pkg.scripts = {
  ...pkg.scripts,
  "lint": "ng lint",
  "format": "prettier --write ."
};
fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2));
'
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







