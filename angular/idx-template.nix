{ pkgs, ... }: {
  channel = "stable-24.11";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    # Create new angular project
    npx --prefer-offline -y @angular/cli new --skip-git --defaults --skip-install --directory "$WS_NAME" "$WS_NAME"
    
    # Create .idx dir and copy configs
    mkdir "$WS_NAME"/.idx
    cp ${./dev.nix} "$WS_NAME"/.idx/dev.nix && chmod +w "$WS_NAME"/.idx/dev.nix
    cp -rf ${./.idx/airules.md} "$WS_NAME"/.idx/airules.md
    cp -rf ${./.idx/eslint.config.js} "$WS_NAME"/.idx/eslint.config.js
    cp -rf ${./.idx/update-pkg.js} "$WS_NAME"/.idx/update-pkg.js
    
    # Move project to final location
    mv "$WS_NAME" "$out"
    chmod -R u+w "$out"
    
    # Copy GEMINI.md
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"

    # Run update script and install dependencies
    (cd "$out"; node ./.idx/update-pkg.js; rm ./.idx/update-pkg.js; npm install --package-lock-only --ignore-scripts)
  '';
}

