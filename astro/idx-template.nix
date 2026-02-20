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
    cd "$out"
    GIT_FLAG=${if git then "--git" else "--no-git"}

    ${
      if packageManager == "npm" then "npm create astro@${version} . -- --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
      else if packageManager == "yarn" then "yarn create astro . --template ${template} --typescript ${typescript} $GIT_FLAG --no-install" 
      else if packageManager == "pnpm" then "pnpm create astro . --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
      else if packageManager == "bun" then "bun create astro . --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
      else "npm create astro@${version} . -- --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
    }

    mkdir -p ./.idx
    packageManager=${packageManager} tailwind=${if tailwind then "true" else "false"} j2 ${./devNix.j2} -o ./.idx/dev.nix
    nixfmt ./.idx/dev.nix

    cp -rf ${./.idx/airules.md} ./.idx/airules.md
    cp -rf ./.idx/airules.md ./GEMINI.md
    
    # Copy our custom ESLint config from the template's .idx directory.
    cp -f ${./.idx/eslint.config.js} ./eslint.config.js

    # Copy and run the helper script to update package.json using the correct node.
    cp -f ${./.idx/update-pkg.js} ./update-pkg.js
    ${pkgs.nodejs_20}/bin/node ./update-pkg.js
    rm ./update-pkg.js # Clean up the script after use.

    # Create prettier ignore
    cat <<EOF > ./.prettierignore
dist
.astro
EOF
    
    chmod -R u+w .
    
    ${if packageManager == "npm" then "npm i --package-lock-only --ignore-scripts" else ""}
  '';
}


