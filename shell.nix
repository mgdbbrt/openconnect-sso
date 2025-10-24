{
  callPackage,
  mkShell,
  stdenv,

  qt6,

  poetry,
  pre-commit,

  gawk,
  git,
  gnumake,
  which,
}:
let
  inherit (callPackage ./. { }) openconnect-sso;

  # qtLibsFor =
  #   let
  #     inherit (lib)
  #       concatStrings
  #       filter
  #       head
  #       getName
  #       splitVersion
  #       take
  #       ;
  #   in
  #   dep:
  #   let
  #     qtbase = head (filter (d: getName d.name == "qtbase") dep.nativeBuildInputs);
  #     version = splitVersion qtbase.version;
  #     majorMinor = concatStrings (take 2 version);
  #   in
  #   pkgs."libsForQt${majorMinor}";
  #
  # qtLibs = qtLibsFor python3Packages.pyqt5;

  qtwrapper = stdenv.mkDerivation {
    name = "qtwrapper";
    dontWrapQtApps = true;
    makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];
    unpackPhase = ":";

    nativeBuildInputs = [
      qt6.qtbase
      qt6.wrapQtAppsHook
    ];

    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/wrap-qt <<'EOF'
      #!/bin/sh
      "$@"
      EOF
      chmod +x $out/bin/wrap-qt
      wrapQtApp $out/bin/wrap-qt
    '';
  };
in

mkShell {
  buildInputs = [
    poetry
    pre-commit

    gawk
    git
    gnumake
    which
  ]
  ++ openconnect-sso.propagatedBuildInputs;

  shellHook = ''
    # Python wheels are ZIP files which cannot contain timestamps prior to 1980
    export SOURCE_DATE_EPOCH=315532800
    # Helper for tests to find Qt libraries
    export NIX_QTWRAPPER=${qtwrapper}/bin/wrap-qt

    echo "Run 'make help' for available commands"
  '';
}
