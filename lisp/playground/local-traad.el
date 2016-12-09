(setq traad-server-port-actual 61000)

(defun init-traad-hooks ()
  (local-set-key (kbd "M-.") 'traad-goto-definition))

(add-hook 'python-mode-hook 'init-traad-hooks)

(provide 'local-traad)
