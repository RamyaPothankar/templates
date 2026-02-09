{ pkgs, language ? "js", ... }: {
  packages = [
    pkgs.nodejs_20
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    npm create -y vite@latest "$WS_NAME" -- --template ${if language == "ts" then "svelte-ts" else "svelte"}

    # --- Start of ADDED ESLint/Prettier Integration ---
    # Enter the new project directory to configure it.
    cd "$WS_NAME"

    # Remove the default ESLint config created by Vite, if it exists.
    rm -f ./.eslintrc.cjs

    # Copy our custom ESLint config from the template's .idx directory.
    cp -f ${./.idx/eslint.config.js} ./eslint.config.js

    # Copy and run the helper script to update package.json with ESLint/Prettier dependencies.
    cp -f ${./.idx/update-pkg.cjs} ./update-pkg.cjs
    node ./update-pkg.cjs
    rm ./update-pkg.cjs # Clean up the script after use.

    # Now, install all dependencies (including the new ones).
    npm install --ignore-scripts

    # Go back to the original directory to finalize the template setup.
    cd ..
    # --- End of ADDED ESLint/Prettier Integration ---

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
  '';
}
