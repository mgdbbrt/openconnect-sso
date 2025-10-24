{
  lib,
  buildPythonApplication,

  # build-system
  poetry-core,

  # dependencies
  openconnect,

  pyqt6,
  pyqt6-webengine,
  pysocks,

  attrs,
  colorama,
  keyring,
  lxml,
  prompt-toolkit,
  pyotp,
  pyxdg,
  requests,
  structlog,
  toml,
}:

buildPythonApplication {
  pname = "openconnect-sso";
  version = "0.8.1";
  pyproject = true;

  src = ../.;

  propagatedBuildInputs = [ openconnect ];

  build-system = [ poetry-core ];

  dependencies = [
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
  ];

  pythonRelaxDeps = [
    "keyring"
  ];

  meta = {
    description = "Wrapper script for OpenConnect supporting Azure AD (SAMLv2) authentication to Cisco SSL-VPNs";
    homepage = "https://github.com/mgdbbrt/openconnect-sso";
    license = lib.licenses.gpl3Only;
  };
}
