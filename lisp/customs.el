;;
;; Some global keybindings, basic modes configuration lives here

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq ns-function-modifier 'hyper)

(set-default-font "Consolas-11")
(set-fontset-font "fontset-default" 'cyrillic '("consolas" . "utf-8"))
(set-face-attribute 'default nil :height 125)

(setq inhibit-startup-message t)
(setq default-tab-width 4)
(setq x-select-enable-clipboard t)

(global-font-lock-mode 1)
(tool-bar-mode -1)
(global-hl-line-mode 0)
(windmove-default-keybindings 'super)
(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key [kp-delete] 'delete-char)
(global-set-key [C-kp-delete] 'delete-word)

(put 'upcase-region 'disabled nil)
(pending-delete-mode 1)

(global-set-key [f5] 'call-last-kbd-macro)
(global-set-key [f8] 'linum-mode)
(global-set-key [f11] 'ibuffer)
(global-set-key [f10] 'bookmark-bmenu-list)

(setq inhibit-startup-message t)
(setq default-tab-width 4)
(setq x-select-enable-clipboard t)

(global-set-key (kbd "C-x C-p") 'pp-eval-last-sexp)

(global-set-key (kbd "C-<backspace>") 'backward-kill-word)
(global-set-key (kbd "C-<delete>") 'kill-word)
(global-set-key (kbd "C-c C-k") 'eval-buffer)

(setq dired-listing-switches "-alhk")

(setq history-length 1000)

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)

(global-set-key (kbd "C-x '") 'toggle-truncate-lines)

(defun my-pretty-lambda ()
  "make some word or string show as pretty Unicode symbols"
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955) ; λ
          )))
(add-hook 'emacs-lisp-mode-hook 'my-pretty-lambda)
(global-prettify-symbols-mode 1)

;; ends
(provide 'customs)
