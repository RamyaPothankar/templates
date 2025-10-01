{ pkgs, ... }: {
  channel = "stable-24.11";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    npm i -g @ionic/cli cordova
    ionic start "$WS_NAME" blank --type=angular --no-deps --no-git --no-interactive
    mkdir "$WS_NAME"/.idx
    cp ${./dev.nix} "$WS_NAME"/.idx/dev.nix && chmod +w "$WS_NAME"/.idx/dev.nix
    mv "$WS_NAME" "$out"
    
    mkdir -p "$out/.idx"

    chmod -R u+w "$out"
    
    (cd "$out"; npm install --package-lock-only --ignore-scripts)
  '';
}
