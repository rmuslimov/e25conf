
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-log-messages nil)

(defun my-clojure-mode-hook ()
  (interactive)
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import
  (cljr-add-keybindings-with-prefix "C-c RET")
  (local-set-key (kbd "M-/") 'complete-symbol))

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'my-clojure-mode-hook)

;; This makes love with cljs in emacs
(setq
 cider-cljs-lein-repl
 "(do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/start-figwheel!) (figwheel-sidecar.repl-api/cljs-repl))")

;; This makes code-reloading works in clj
(setq cider-refresh-before-fn "reloaded.repl/suspend"
	  cider-refresh-after-fn "reloaded.repl/resume")

(provide 'local-clojure)
