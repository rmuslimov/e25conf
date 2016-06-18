;;
;; Function's set for Getgoing Inc.
;;
(require 'cl-lib)

(defun getgoing-arc-dance (new-branch-name)
  "Create new branch for arcanist."
  (interactive "sEnter branch name: ")
  (let ((prev-branch (magit-get-current-branch)))
    (progn
      (magit-branch new-branch-name prev-branch)
      (magit-checkout new-branch-name)
      (magit-branch-set-upstream new-branch-name prev-branch)
      (magit-status))))

(defun getgoing-arc-find-lint-exception ()
  (interactive)
  (let* ((lintstring "Lint for")
         (fileaddr
          (save-excursion
            (progn
              (re-search-backward lintstring)
              (forward-char (length lintstring))
              (setq begpoint (point))
              (message (format "%s" begpoint))
              (re-search-forward ":")
              (backward-char 2)
              (substring-no-properties (buffer-string) begpoint (point))
              )))
         (line-number
          (save-excursion
            (progn
              (move-beginning-of-line nil)
              (re-search-forward "[0-9]+")
              (re-search-backward " ")
              (setq begpoint (point))
              (forward-char 1)
              (re-search-forward " ")
              (backward-char 1)
              (substring-no-properties (buffer-string) begpoint (point))
              ))))

    (progn
      (find-file-other-window (concat "~/projects/airborne/" fileaddr))
      (goto-line (string-to-number line-number)))
    ))

(global-set-key (kbd "C-c p e") 'arc-find-lint-exception)

;; ------------------- JIRA issues

(defconst JIRAURL "https://getgoing.atlassian.net/browse/GG-")

(defun getgoing-open-jira-issue (issue-number)
  (interactive "sIssue number: ")
  (browse-url (concat JIRAURL issue-number)))

(cl-defstruct jira-issue id title)
;; (make-jira-issue :id "as" :title "as")

(defun assoc-recursive (alist &rest keys)
  "Recursively find KEYs in ALIST."
  (while keys
    (setq alist (cdr (assoc (pop keys) alist))))
  alist)

(defun getgoing--read-issue (issue)
  (let ((id (cdr (assoc 'key issue)))
        (title (assoc-recursive issue 'fields 'summary)))
    (cons id (make-jira-issue :id id :title title))))

(defun getgoing-parse-json-from-jira ()
  "Suppose that *jira-tasks* data is set"
  (interactive)
  (let* ((issues-raw (cdr (assoc 'issues *jira-tasks*)))
         (issues (mapcar #'getgoing--read-issue issues-raw)))
    (cl-flet
        ((format-issue-func
          (issue-cons)
          (format "%s %s"
                  (jira-issue-id (cdr issue-cons))
                  (jira-issue-title (cdr issue-cons))))
         (insert-into
          (value)
          (insert (format "** %s\n" value))))
      (mapcar #'insert-into
       (mapcar #'format-issue-func issues)))))


(provide 'local-getgoing)
