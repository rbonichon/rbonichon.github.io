with import <nixpkgs> { };
mkShell {
  name = "rbonichon-github-io";
  packages = [
    # Build
    # org-publish via emacs --batch, which skips init.el: the packages
    # rb-website.el needs must come with the emacs itself.
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
      epkgs.yaml       # data/biblio.yml → src-org/biblio.org
    ]))
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
