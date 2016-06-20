setq EMACSHOME "~/projects/emacsworkshop/e25/")
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize EMACSHOME)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(pyvenv-workon 'emacs25)

(add-to-list 'load-path (format "%slisp" EMACSHOME))
(add-to-list 'load-path (format "%slisp/playground" EMACSHOME))
(add-to-list 'load-path (format "%slisp/python" EMACSHOME))

;; Load my global settings for external packages from elpa/melpa/etc.
(load-file (format "%slisp/init.el" EMACSHOME))

;; My custom elisp functions
(load-file (format "%slisp/playground/init.el" EMACSHOME))

;; My custom elisp functions
(load-file (format "%slisp/python/init.el" EMACSHOME))

(find-file (format "%sinit.el" EMACSHOME))

(yas-global-mode 1)
(add-to-list 'yas-snippet-dirs (format "%ssnippets" EMACSHOME))

(message "Emacs 25!")
