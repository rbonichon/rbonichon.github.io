with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    git
    hugo
    gnumake
  ];
}
