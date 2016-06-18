(setq
 scripts-dired-find-owner
 "tell application \"Finder\"
  set appname to (default application of (info for POSIX file \"%s\"))
  do shell script \"echo \" & appname
end tell")

(setq
 scripts-dired-open-from-finder
 "tell application \"Finder\" to open POSIX file \"%s\"")

(setq
 scripts-dired-reveal-in-finder
 "tell application \"Finder\"
  reveal POSIX file \"%s\"
  activate
end tell")

(defun my-dired-external-open ()
  "SIMPLE HOOK TO OPEN FILE IN FINDER DEFAULT APPLICATION."
  (interactive)
  (let* ((filename (dired-get-file-for-visit))
		 (whocmd (format scripts-dired-find-owner filename))
		 (owner-app (do-applescript whocmd)))
	(cond
	 ((or (s-contains? "Emacs" owner-app) (file-directory-p filename))
	  (dired-view-file))
	 (t
      (do-applescript (format scripts-dired-open-from-finder filename))))))

(defun my-dired-reveal-in-finder ()
  (interactive)
  (let* ((filename (dired-get-file-for-visit))
         (cmd (format scripts-dired-reveal-in-finder filename)))
    (do-applescript cmd)))

(defun init-dired-hooks ()
  (local-set-key (kbd "M-RET") 'my-dired-external-open)
  (local-set-key (kbd "<s-return>") 'my-dired-reveal-in-finder)
  (dired-omit-mode t))

(require 'dired-x)
(setq dired-omit-files "nil")
(add-hook 'dired-mode-hook 'init-dired-hooks)

(provide 'local-dired)
