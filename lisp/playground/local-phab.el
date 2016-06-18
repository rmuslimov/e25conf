(defun phab--get-commit ()
  "Get ticket from first line"
  (save-excursion
    (beginning-of-buffer)
    (re-search-forward "\\[GG-" nil t)
    (setq beg (point))
    (re-search-forward "\\]" nil t)
    (substring-no-properties (buffer-string) (1- beg) (- (point) 2))))

(defun phab-prepare-review ()
  (interactive)
  "Parse and install defaults"
  (save-excursion
    ;; insert test plan
    (beginning-of-buffer)
    (re-search-forward "Test Plan:")
    ;; (kill-line)
    (insert " -")

    ;; insert default reviewers
    (re-search-forward "Reviewers:")
    ;; (kill-line)
    (insert local-getgoing-devs)

    (let ((rev (phab--get-commit)))
      (re-search-forward "JIRA Issues:")
      ;; (kill-line)
      (insert (format " GG-%s" rev)))))

(provide 'local-phab)
