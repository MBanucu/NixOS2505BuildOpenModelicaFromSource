# openmodelica.nix
{
  openmodelica-core,
  stdenv,
  callPackage,
  lib,
  fetchFromGitHub,
  fetchurl,
  gcc,
  makeWrapper,
  autoconf,
  automake,
  cmake,
  ccache,
  gnumake,
  pkg-config,
  libtool,
  git,
  boost,
  curl,
  expat,
  fontconfig,
  freetype,
  gdb,
  gfortran,
  glibc,
  hdf5,
  libffi,
  libGL,
  libxml2,
  libuuid,
  lp_solve,
  openjdk,
  openblas,
  lapack,
  openssl,
  python2,
  python3,
  qt5,
  readline,
  sundials,
  zlib,
  openscenegraph,
  icu,
  xorg,
  asciidoc,
  doxygen,
  python3Packages,
  flex,
  opencl-clhpp,
  ocl-icd,
  xterm,
  clang,
  zip,
}:

let
  qtVersion = qt5.qtbase.version;
in

stdenv.mkDerivation {
  pname = "openmodelica";
  version = "1.25.0";

  # Use the output of openmodelica-core as the source
  src = openmodelica-core;

  # nativeBuildInputs for wrapping tools
  nativeBuildInputs = [
    makeWrapper
  ];

  # buildInputs for runtime dependencies needed by the wrapped binaries
  buildInputs = [
    zip
    clang
    gcc
    autoconf
    automake
    cmake
    ccache
    gnumake
    pkg-config
    libtool
    git
    boost
    curl
    expat
    fontconfig
    freetype
    gdb
    gfortran
    gfortran.cc.lib
    glibc
    hdf5
    libffi
    libGL
    libGL.dev
    libxml2
    libuuid
    lp_solve
    openjdk
    openblas
    lapack
    openssl
    python2
    python3
    qt5.full
    readline
    readline.dev
    sundials
    zlib
    openscenegraph
    stdenv.cc.libc_dev
    icu
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    asciidoc
    doxygen
    python3Packages.sphinx
    flex
    opencl-clhpp
    ocl-icd
    xterm
  ];

  phases = [
    "installPhase"
    "fixupPhase"
  ];

  # Copy the entire output from openmodelica-core
  installPhase = ''
    mkdir -p $out/bin
  '';

  postFixup = ''
    wrapper_LIBRARY_PATH="${openmodelica-core}/lib/omc:${
      lib.makeLibraryPath [
        boost
        curl
        expat
        fontconfig
        freetype
        gfortran.cc.lib
        glibc.dev
        hdf5
        icu.dev
        libffi
        libGL
        libxml2
        libuuid
        lp_solve
        openblas
        lapack
        openssl
        qt5.full
        readline
        sundials
        zlib
        openscenegraph
        stdenv.cc.libc_dev
        xorg.libX11
        xorg.libXrandr
        xorg.libXinerama
        xorg.libXcursor
      ]
    }"

    # Create the alias by symlinking x-terminal-emulator to xterm
    ln -s ${xterm}/bin/xterm $out/bin/x-terminal-emulator

    # Wrap all executables in bin/
    for exe in ${openmodelica-core}/bin/*; do
      if [ -x "$exe" ] && [ ! -L "$exe" ]; then
        echo "wrapping $exe"
        makeWrapper "$exe" "$out/bin/$(basename $exe)" \
          --prefix LD_LIBRARY_PATH : $wrapper_LIBRARY_PATH \
          --prefix LIBRARY_PATH : $wrapper_LIBRARY_PATH \
          --prefix QT_PLUGIN_PATH : "${qt5.full}/lib/qt-${qtVersion}/plugins" \
          --prefix PATH : "${cmake}/bin" \
          --prefix PATH : "${clang}/bin" \
          --prefix PATH : "${zip}/bin"
      fi
    done
  '';

  meta = with lib; {
    description = "OpenModelica with wrapped binaries to execute";
    homepage = "https://openmodelica.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
