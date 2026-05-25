with import <nixpkgs> { };
mkShell {
  name = "rbonichon-github-io";
  packages = [
    # Build
    emacs            # org-publish via emacs --batch
    gnumake          # Makefile

    # Preview / dev
    python3          # http.server pour `make serve`
    inotify-tools    # inotifywait pour `make watch`

    # Publication / vérif
    git              # commit + push docs/ submodule
    xdg-utils        # xdg-open pour ouvrir le navigateur
    linkchecker      # validation des liens
  ];
}
