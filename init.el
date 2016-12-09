
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
;; (cask-initialize)
(setq EMACSHOME "~/.emacs.d/")
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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(js2-mode web-mode company-tern tern traad smex smart-mode-line pyvenv projectile prodigy nameless markdown-mode magit jenkins ido-vertical-mode ido-ubiquitous ido-at-point flycheck exec-path-from-shell es-mode epc edit-server company clj-refactor browse-kill-ring+ beacon bash-completion avy autopair anaconda-mode ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
