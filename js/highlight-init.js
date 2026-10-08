// Colours org-html source blocks with highlight.js.  org-html marks them
// <pre class="src src-LANG">, with LANG the org language name; map it to
// highlight.js's name where they differ.
(function () {
  var aliases = { "emacs-lisp": "lisp", elisp: "lisp", sh: "bash", shell: "bash" };
  document.querySelectorAll("pre.src").forEach(function (block) {
    var match = block.className.match(/\bsrc-(\S+)/);
    if (!match) return;
    var lang = aliases[match[1]] || match[1];
    if (!hljs.getLanguage(lang)) return;
    block.classList.add("language-" + lang);
    hljs.highlightElement(block);
  });
})();
