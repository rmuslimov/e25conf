;; Customize external packages lives here

(add-hook 'after-init-hook 'global-company-mode)

(global-set-key (kbd "C-x l") 'pianobar-next-song)
(global-set-key (kbd "C-x m") 'magit-status)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(ido-vertical-mode t)
(ido-at-point-mode)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(bash-completion-setup)

(when (require 'edit-server nil t)
  (setq edit-server-new-frame nil)
  (edit-server-start))

(global-set-key "\M-y" 'browse-kill-ring)
(global-set-key (kbd "M-/") 'company-complete)
(add-hook 'emacs-lisp-mode-hook #'nameless-mode)

(define-key global-map (kbd "C-c j") 'ace-jump-mode)

(add-to-list 'auto-mode-alist '("\\.es$" . es-mode))

(setq company-auto-complete t)
(setq company-minimum-prefix-length 2)

(setq send-mail-function (quote smtpmail-send-it))

(show-paren-mode t)

(setq magit-push-always-verify t)

(setq sml/no-confirm-load-theme t)
(sml/setup)

(provide 'packages)
