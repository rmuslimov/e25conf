(add-to-list 'load-path (expand-file-name "~/projects/flycheck-local-flake8"))
(load-file (expand-file-name "~/projects/flycheck-local-flake8/flycheck-local-flake8.el"))

(add-hook
 'flycheck-before-syntax-check-hook
 #'flycheck-local-flake8/flycheck-virtualenv-set-python-executables 'local)

(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'linum-mode)
(add-hook 'python-mode-hook 'autopair-mode)

(setq flycheck-highlighting-mode 'lines)
(setq flycheck-check-syntax-automatically '(mode-enabled save))

(provide 'local-flycheck)
