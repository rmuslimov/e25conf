;; (add-hook 'shell-mode-hook 'my-shell-mode-hook)
;; (defun my-shell-mode-hook ()
;;   (process-send-string (get-buffer-process (current-buffer))
;;                        "export VARIABLE=VALUE\n"))

(provide 'local-sandbox)
