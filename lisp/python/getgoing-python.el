;; -*- lexical-binding:t -*-

(defconst getgoing--main-projects
  (list 'airborne 'bowman 'cessna 'fokker 'fasttrace))

(defconst dependency-projects
  (list 'hyatt 'quicksilver 'radisson 'courtyard 'atlas 'boeing 'mcdonnell))

(defun getgoing--project-path (project)
  (f-join "~/projects" (symbol-name project)))

(defun getgoing-dependencies-path ()
  (s-join ":" (-map 'getgoing--project-path dependency-projects)))


(defun python-env-for-project (name)
  "Generate python env variables."
  (let* ((project-name (symbol-name name))
		 (venv (expand-file-name (format "~/.virtualenvs/%s" project-name))))
  `(("PATH" . ,(expand-file-name (format "~/.virtualenvs/%s/bin:$PATH;" project-name)))
	("PYTHONHOME" . ,venv)
	("PYTHONPATH" . ,(getgoing--project-path name))
	("VIRTUAL_ENV" . ,venv)
	("PYTHONIOENCODING" . "utf-8"))))

(defun getgoing--get-env-for-project (name)
  "Get env variables format given project."
  (let* ((project-name (symbol-name name))
		 (venv (expand-file-name (format "~/.virtualenvs/%s" project-name))))
  `(("PATH" . ,(expand-file-name (format "~/.virtualenvs/%s/bin:$PATH;" project-name)))
	("PYTHONHOME" ,venv)
	("PYTHONPATH" ,(format "%s:%s" (getgoing--project-path name) (getgoing-dependencies-path)))
	("VIRTUAL_ENV" ,venv)
	("PYTHONIOENCODING" "utf-8"))))

(defun getgoing--get-ready-env-for-project (name)
  "Ready to paste list of export for projects."
  (apply 's-concat
		 (-map
		  (lambda (pair) (format "export %s=%s\n" (car pair) (cdr pair)))
		  (getgoing--get-env-for-project name))))

(defun setup-shell-project (name)
  "Run shell with pre-installed python envs."
  (interactive (list (intern (completing-read "Choose project: " getgoing--main-projects))))
  (let* ((new-buffer-name (format "shell-%s" (symbol-name name)))
		 (default-directory (getgoing--project-path name)))
	(if (get-buffer new-buffer-name)
		(switch-to-buffer new-buffer-name)
	  (progn
		(shell)
		(rename-buffer new-buffer-name)

		;; Set variable to specific project
		(process-send-string
		 (get-buffer-process (current-buffer))
		 (getgoing--get-ready-env-for-project name))))))

(global-set-key (kbd "C-c RET p s") 'setup-shell-project)

(provide 'getgoing-python)
