;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-dark+)

(setq org-directory "/mnt/c/Users/simon/Dropbox/org/")

(use-package! org-ql)

(after! org-agenda
  (org-super-agenda-mode))
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
         ((agenda "")
          (alltodo "")))
        ("g" "GTD agenda"
         ((agenda "")
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-header-map nil)
                       (org-super-agenda-groups
                        '(;; Each group has an implicit boolean OR operator between its selectors. Thus sequence of selector is matter.
                          (:name "All actions ready to be execute"
                           :discard (:habit t)
                           :todo "TODO"
                           )
                          (:discard (:anything t))
                          ))))))))

(setq org-gtd-directory "/mnt/c/Users/simon/Dropbox/org/gtd/")
(setq org-agenda-files (list org-gtd-directory))

(use-package! org-gtd
  :after org org-agenda org-super-agenda
  :init
  (setq org-gtd-update-ack "3.0.0")
  :custom
  (org-gtd-next "TODO")
  (org-gtd-next-suffix "(t)")
  (org-gtd-todo "NEXT")
  (org-gtd-todo-suffix "(n)")
  (org-gtd-engage-prefix-width 24)
  :config
  (defun org-gtd-habit-create (&optional repeater)
    "Add a repeater to this item and store in org gtd.

If you want to call this non-interactively,
REPEATER is `org-mode'-style repeater string (.e.g \".+3d\") which will
determine how often you'll be reminded of this habit."
    (let ((repeater (or repeater
                        (read-from-minibuffer "How do you want this to repeat? ")))
          (today (format-time-string "%Y-%m-%d")))
      (org-schedule nil (format "<%s %s>" today repeater))
      (org-entry-put (point) "STYLE" "habit"))
    (org-todo org-gtd-next)
    (setq-local org-gtd--organize-type 'habit)
    (org-gtd-organize-apply-hooks)
    (org-gtd-refile--do org-gtd-habit org-gtd-habit-template))
  (setq org-gtd-habit-func #'org-gtd-habit-create)

  (defun org-gtd-calendar-create (&optional appointment-date)
    "Add a date/time to this item and store in org gtd.

You can pass APPOINTMENT-DATE as a YYYY-MM-DD or YYYY-MM-DD HH:MM string if you want to use this
non-interactively."
    (let* ((date-string (or appointment-date
                            (org-read-date t nil nil "When is this going to happen? "))) ;; Ensure time is also allowed
           ;; Convert the date string to a time value
           (time-value (org-time-string-to-time date-string))
           ;; Check if the date string includes a time part (HH:MM)
           (includes-time (string-match "\\([0-9]\\{2\\}:[0-9]\\{2\\}\\)" date-string))
           ;; Format the time value to include the day of the week, and time if present
           (formatted-date (if includes-time
                               (format-time-string "<%Y-%m-%d %a %H:%M>" time-value)
                             (format-time-string "<%Y-%m-%d %a>" time-value))))
      (org-entry-put (point) "org-gtd-timestamp" formatted-date) ;; Assuming 'org-gtd-timestamp' is a correct property
      ;; No need for orgzly support, as mentioned
      ;; (save-excursion
      ;;   (org-end-of-meta-data t)
      ;;   (open-line 1)
      ;;   (insert formatted-date))
      (setq-local org-gtd--organize-type 'calendar)
      (org-gtd-organize-apply-hooks)
      (org-gtd-refile--do org-gtd-calendar org-gtd-calendar-template)))
  (setq org-gtd-calendar-func #'org-gtd-calendar-create)

  (defun org-gtd-engage ()
    "Display `org-agenda' customized by org-gtd."
    (interactive)
    (org-gtd-core-prepare-agenda-buffers)
    (with-org-gtd-context
        (let* ((project-format-prefix
                (format " %%i %%-%d:(org-gtd-agenda--prefix-format) "
                        org-gtd-engage-prefix-width))
               (org-agenda-custom-commands
                `(("g" "Scheduled today and all NEXT items"
                   ((agenda ""
                            ((org-agenda-span 1)
                             (org-agenda-start-day nil)
                             (org-agenda-skip-additional-timestamps-same-entry t)))
                    (alltodo ""
                             ((org-agenda-overriding-header "")
                              (org-super-agenda-header-map nil)
                              (org-super-agenda-groups
                               '(;; Each group has an implicit boolean OR operator between its selectors. Thus sequence of selector is matter.
                                 (:name "All actions ready to be executed."
                                  :discard (:habit t)
                                  :todo "TODO"
                                  )
                                 (:discard (:anything t))
                                 ))
                              (org-agenda-prefix-format
                               '((todo . ,project-format-prefix))))))))))
          (org-agenda nil "g")
          (goto-char (point-min)))))

  (org-gtd-mode))

(use-package! xterm-color)

(after! eshell
  (add-hook 'eshell-before-prompt-hook
            (lambda ()
              (setq xterm-color-preserve-properties t)))
  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
  (setq eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
  (setenv "TERM" "xterm-256color"))

(setq display-line-numbers-type t)

(after! js-comint
  (defun js-comint-mode-hook-setup ()
    (add-hook 'comint-output-filter-functions #'xterm-color-filter -90 t)
    (setq-local ansi-color-for-comint-mode 'filter))
  (add-hook 'js-comint-mode-hook 'js-comint-mode-hook-setup t))

(after! apheleia
  (use-package! lsp-biome))

(after! eshell-did-you-mean
  (defun eshell-did-you-mean--get-all-commands ()
    "Feed `eshell-did-you-mean--all-commands'."
    (unless eshell-did-you-mean--all-commands
      (setq eshell-did-you-mean--all-commands (all-completions "" (pcomplete-completions))))))

(use-package! rime
  :init (setq default-input-method "rime"))

(setq-default tab-width 2)
(setq js-indent-level 2)
(setq css-indent-offset 2)
