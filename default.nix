{
  lib,
  callPackage,
  python3Packages,
}:

{
  openconnect-sso = callPackage ./nix/openconnect-sso.nix {
    inherit (python3Packages)
      buildPythonApplication
      poetry-core

      pyqt6
      pyqt6-webengine
      pysocks

      attrs
      colorama
      keyring
      lxml
      prompt-toolkit
      pyotp
      pyxdg
      requests
      structlog
      toml
      ;
  };
}
