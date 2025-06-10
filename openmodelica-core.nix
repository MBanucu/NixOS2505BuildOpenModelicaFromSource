{
  stdenv,
  lib,
  fetchzip,
  fetchurl,
  fetchFromGitHub,
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
}:

let
  qtVersion = qt5.qtbase.version;

  # Fetch and unpack the OMBootstrapping tarball
  ombootstrapping = fetchzip {
    url = "https://github.com/OpenModelica/OMBootstrapping/archive/91938f0acbdc6e9ba91114376e3640ca6147b579.tar.gz";
    sha256 = "sha256-t5nwkuwJ2kuLdbvQ92HGdFcgNdlgoMOVVOgznwoe9/Y=";
  };

  ombootstrappingTarball = fetchurl {
    url = "https://github.com/OpenModelica/OMBootstrapping/archive/91938f0acbdc6e9ba91114376e3640ca6147b579.tar.gz";
    sha256 = "sha256-GgMn2r7dCdqzqocq8ZS21OebrMRWWeoxVAdufx9Ussw=";
  };
in

stdenv.mkDerivation {
  pname = "openmodelica-core";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "OpenModelica";
    repo = "OpenModelica";
    rev = "v1.25.0";
    sha256 = "sha256-2cdxMMyk+JmkgllRc+0uPowIVdx9IDZ5gAOJk0fKwB0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    makeWrapper
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
  ];

  cmakeFlags = [
    "-DOM_OMC_ENABLE_FORTRAN=OFF"
    "-DOM_OMC_ENABLE_IPOPT=OFF"
    "-DOM_OMEDIT_ENABLE_QTWEBENGINE=ON"
  ];

  preConfigure = ''
    # Replace -isystem with -I in NIX_CFLAGS_COMPILE
    export NIX_CFLAGS_COMPILE=$(echo "$NIX_CFLAGS_COMPILE" | sed 's/-isystem /-I/g')

    # Create the target directory
    mkdir -p OMCompiler/Compiler/boot/bomc

    # Copy the unpacked contents of OMBootstrapping to the target directory
    cp -r ${ombootstrapping}/* OMCompiler/Compiler/boot/bomc

    # Copy the original tarball to the target directory
    cp ${ombootstrappingTarball} OMCompiler/Compiler/boot/bomc/sources.tar.gz

    # Verify that the expected files exist
    if [ ! -f OMCompiler/Compiler/boot/bomc/sources.tar.gz ]; then
      echo "Error: sources.tar.gz not found in OMBootstrapping."
      exit 1
    fi
    if [ ! -f OMCompiler/Compiler/boot/bomc/tarball-include/OpenModelicaBootstrappingHeader.h ]; then
      echo "Error: OpenModelicaBootstrappingHeader.h not found after extraction."
      exit 1
    fi

    # Configure ccache to use a writable directory within TMPDIR
    export CCACHE_DIR=$TMPDIR/ccache
    mkdir -p $CCACHE_DIR
    export CCACHE_NOHASHDIR=1
  '';

  preFixup = ''
    # Fix broken paths
    sed -i "s|$out/||g" $out/lib/omc/pkgconfig/cminpack.pc
    sed -i 's|//omc|/omc|g' $out/lib/omc/pkgconfig/cminpack.pc
    sed -i 's|omc//|omc/|g' $out/lib/omc/pkgconfig/cminpack.pc
  '';

  meta = with lib; {
    description = "OpenModelica is an open-source Modelica-based modeling and simulation environment";
    homepage = "https://openmodelica.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
