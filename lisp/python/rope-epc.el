;; -*- lexical-binding: t -*-

(defmacro complement (function)
  `(lambda (&rest args)
     (not (apply ,function args))))
(require 'epc)

(setq epc (start-epc))

(defun start-epc ()
  (let* ((rope-buffer (rope-process-buffer 'ropeepc))
		 (rope-port (with-current-buffer rope-buffer (s-replace "\n" "" (buffer-string))))
		 (mngr (make-epc:manager
				:server-process (get-buffer-process rope-buffer)
				:commands (cons "python" "main.py")
				:title "title"
				:port rope-port
				:connection (epc:connect "localhost" rope-port))))
	(epc:init-epc-layer mngr)
	mngr))

(defun rope-process-buffer (envname)
  "Return process with rope"
  (let* ((envname-s (symbol-name envname))
		 (buffer (get-buffer-create "rope-process"))
		 (pyvenv-workon envname-s))
	(with-current-buffer buffer
	  (pyvenv-track-virtualenv)
	  (let ((default-directory (expand-file-name (format "~/projects/%s" envname-s))))
		(start-process "rope-process" buffer "python" "main.py")))
	buffer))

(defun rope--process-get-definition-response (response)
  (when (plist-get response :status)
	(let ((filename (-first (complement 's-blank?) (list (plist-get response :path) (buffer-file-name))))
		  (point (plist-get response :offset))
		  (lineno (plist-get response :lineno)))
	  (with-current-buffer
	   (find-file (f-join (vc-git-root (buffer-file-name)) filename))
	   (goto-line lineno)))
	))

(defun rope-get-definition ()
  (interactive)
  "Ask from rope about given artefact and locate to returned object."
  (deferred:$
	(epc:call-deferred
	 epc 'find_definition
	 `(,(vc-git-root (buffer-file-name))
	   ,(buffer-substring-no-properties 1 (point-max)) ,(point)))
	(deferred:nextc it 'rope--process-get-definition-response)))

(global-set-key (kbd "C-c g") 'rope-get-definition)

(deferred:$
  (epc:call-deferred epc 'echo '("hey"))
  (deferred:nextc it
    (lambda (x) (message "Return : %S" x))))

(deferred:$
  (epc:call-deferred
   epc 'find-definition
   '(,(expand-file-name "~/projects/airborne") "hyatt_build_entity_fast"))
  (deferred:nextc it
    (lambda (x) (message "Return : %S" x))))

;; calling synchronously
(message "%S" (epc:call-sync epc 'echo '(10)))

;; Request peer's methods
(message "%S" (epc:sync epc (epc:query-methods-deferred epc)))

(epc:stop-epc epc)
