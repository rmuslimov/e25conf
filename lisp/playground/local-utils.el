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


(defun resort-region ()
  (interactive)
  (let* (
         (selected (buffer-substring-no-properties (region-beginning) (region-end)))
         (parents (-map 's-trim (s-split "," selected)))
         (response (s-join ", " (-sort 'string< parents))))
    (delete-region (region-beginning) (region-end))
    (insert response)))

(defun uniq-lines (beg end)
  "Unique lines in region.
Called from a program, there are two arguments:
BEG and END (region to sort)."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (not (eobp))
        (kill-line 1)
        (yank)
        (let ((next-line (point)))
          (while
              (re-search-forward
               (format "^%s" (regexp-quote (car kill-ring))) nil t)
            (replace-match "" nil nil))
          (goto-char next-line))))))



(provide 'local-utils)
