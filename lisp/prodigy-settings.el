

(defconst prodigy-standard-python-service
  '((airborne :args ("manage.py" "runserver" "5000"))
    (airborne-gunicorn
     :command "gunicorn"
     :args ("wsgi:application" "-c" "gunicorn_conf.py" "-w" "2" "--log-file=-"))
    (airborne-celery
     :args ("manage.py" "celeryd" "-l" "info" "-c" "3" "-P" "eventlet" "-Q" "airborne_celery,airborne_booking_queue"))
    (airborne-hyattfast
     :args ("manage.py" "celeryd" "-l" "info" "-c" "1" "-P" "eventlet" "-Q" "hyatt_fast_queue"))
    (bowman
     :command "celery"
     :args ("worker" "-A" "bowman.celeryconfig" "-n" "bowman_celery"
            "-Q" "bowman_celery,bowman_booking_celery" "-P" "eventlet"
            "-c" "3" "-l" "info"))
    (fasttrace :args ("-m" "fasttrace.web.app" "8080"))
    (fokker
     :args ("worker" "-A" "fokker.celery" "-n" "fokker-worker-1"
            "-Q" "fokker_search_celery,fokker_booking_celery" "-c" "3"
            "-l" "info" "-P" "eventlet")
     :command "celery")
    (cessna
     :args ("-m" "celery.bin.worker" "-A" "cessna.celeryconfig" "-n" "cessna-worker"
            "-l" "info" "-c" "3" "-P" "eventlet" "-Q" "cessna_search_celery,cessna_booking_celery"))))

(require 'getgoing-python)

;; Setup tags
(dolist (item getgoing--main-projects)
  (prodigy-define-tag
	:name (intern (format "%s-tag" item))
	:env (getgoing--get-env-for-project item)))

;; (getgoing--get-env-for-project 'airborne)
;; Setup python services
(dolist (appname (-map 'car prodigy-standard-python-service))
  (let* ((appname-s (symbol-name appname))
		 (envname (car (s-split "-" appname-s)))
		 (override (cdr (assoc appname prodigy-standard-python-service))))
	(prodigy-define-service
	  :name (s-capitalize appname-s)
	  :command (or (plist-get override :command) "python")
	  :args (plist-get override :args)
	  :cwd (getgoing--project-path (intern envname))
	  :tags `(work ,(intern (format "%s-tag" envname)))
	  :kill-signal 'sigkill)))

;; Install other apps to prodigy
(prodigy-define-service
  :name "Memcached"
  :command "/usr/local/bin/memcached"
  :args '("-I" "1M" "-m" "2048")
  :cwd "~"
  :tags '(work util)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "ElasticSearch"
  :command "elasticsearch"
  :path '("/usr/local/bin")
  :cwd "~"
  :tags '(work util)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "RabbitMq"
  :command "rabbitmq-server"
  :path '("/usr/local/sbin/")
  :tags '(work util)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "Datomic"
  :command "transactor"
  :args '("/Users/rmuslimov/projects/clojure/datomic/config/samples/free-transactor-template.properties")
  :path '("/Users/rmuslimov/projects/clojure/datomic/bin")
  :tags '(clojure)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "Datomic Console"
  :command "console"
  :args '("-p" "5080" "mbrainz" "datomic:free://localhost:4334/")
  :path '("/Users/rmuslimov/projects/clojure/datomic/bin")
  :tags '(clojure)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "Redis"
  :command "redis-server"
  :path '("/usr/local/Cellar/redis/3.0.7/bin/")
  :tags '(work)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "Hotreload Airborne"
  :command "babel-node"
  :path '("./node_modules/.bin/")
  :args (list "./.webpack/hotreload.js")
  :cwd "/Users/rmuslimov/projects/airborne/"
  :tags '(work)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "Logstash"
  :command "logstash"
  :path '("./bin")
  :args '("agent" "-f" "~/projects/gaylord/chains/stage/shares/logstash.conf")
  :cwd "/Users/rmuslimov/projects/logstash/"
  :tags '(work elk)
  :kill-signal 'sigkill)
(prodigy-define-service
  :name "Kibana"
  :command "kibana"
  :path '("./bin")
  :cwd "/Users/rmuslimov/projects/kibana/"
  :tags '(work elk)
  :kill-signal 'sigkill)

(defun prodigy-start-by-tag (tag)
  "Start all services having tag."
  (interactive (list (intern (completing-read "Select tag: " (list 'util)))))
  (dolist (item (prodigy-services-tagged-with tag))
	(prodigy-start-service item)))

(provide 'prodigy-settings)
