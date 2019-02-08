(setq current-theme "dark")
(defconst light-theme 'spacemacs-light')
(defconst dark-theme 'spacemacs-dark)

;; will apply dark theme if dark, light theme if light
(defun change-theme-for-lighting ()
  (let* ((current-light-sensor-reading
          (string-to-number
           (shell-command-to-string "./lmutracker"))))
    (if (< current-light-sensor-reading 10000)
        (when (not (string-equal current-theme "dark"))
          (load-theme dark-theme 1)
          (setq current-theme "dark"))
      (when (not (string-equal current-theme "light"))
        (load-theme light-theme 1)
        (setq current-theme "light")))))

;; run every 5m
(run-with-timer 0 300 #'change-theme-for-lighting)
