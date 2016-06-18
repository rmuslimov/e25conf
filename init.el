(setq EMACSHOME "~/projects/emacsworkshop/e25/")
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize EMACSHOME)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(pyvenv-workon 'emacs25)

;; Load my global settings for external packages from elpa/melpa/etc.
(add-to-list 'load-path (format "%slisp" EMACSHOME))
(load-file (format "%slisp/init.el" EMACSHOME))

;; My custom elisp functions
(add-to-list 'load-path (format "%slisp/playground" EMACSHOME))
(load-file (format "%slisp/playground/init.el" EMACSHOME))

(find-file (format "%sinit.el" EMACSHOME))

(message "Emacs 25!")
