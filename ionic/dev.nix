# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_20
    pkgs.unzip # Required for cordova
    (pkgs.buildFHSUserEnv {
      name = "android-env";
      targetPkgs = pkgs: (with pkgs; [
        zulu_17
        gnumake
        android-sdk
      ]);
      runScript = "bash";
    })
  ];
  # Sets environment variables in the workspace
  env = {
    # for android builds
    JAVA_HOME = pkgs.zulu_17;
    ANDROID_SDK_ROOT = "${pkgs.android-sdk}/share/android-sdk";
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ionic.ionic"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        npm-install = "npm ci --no-audit --prefer-offline --no-progress --timing || npm i --no-audit --no-progress --timing";
        # Open editors for the following files by default, if they exist:
        default.openFiles = [
          "src/app/home/home.page.ts"
        ];
      };
      # To run something each time your workspace starts, use the following
      # onStart = {
      #  start-server = "ionic serve";
      # };
    };
  };
}