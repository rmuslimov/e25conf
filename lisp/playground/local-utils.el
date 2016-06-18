(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

(global-set-key (kbd "M-d") 'duplicate-line)

(defun move-line-up ()
  (interactive)
  (transpose-lines 1) (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1) (forward-line -1))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

(defun update-anybar-color (color &optional port)
  (shell-command
   (format "echo -n \"%s\" | nc -4u -w0 localhost %s"
           color (or port 1738))))

(provide 'local-utils)
