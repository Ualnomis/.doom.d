;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-dark+)

(setq org-directory "/mnt/c/Users/simon/Dropbox/org/")
(setq org-gtd-directory "/mnt/c/Users/simon/Dropbox/org/gtd/")

(use-package! org-edna
  :custom
  (org-edna-use-inheritance t)
  (org-edna-mode))

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
                        '(;; Each group has an implicit boolean OR operator between its selectors. Thus the sequence of selector is matter.
                          (:name "INBOX"
                           :todo "INBOX")
                          (:discard (:habit t))
                          (:discard (:todo "NEXT"))
                          (:auto-parent t)
                          (:discard (:anything t))
                          ))))))))

(after! org-capture
  (setq org-capture-templates
        `(
          ;; for gtd
          ("i" "INBOX" entry (file (lambda() (expand-file-name "inbox.org" org-gtd-directory)))
           "* INBOX %?\n:PROPERTIES:\n:DATE_ADDED: %U\n:END:")
          )))

(setq org-agenda-files (list org-gtd-directory))

(after! org
  (setq org-todo-keywords
        `((sequence "TODO(t)" "INBOX(i)" "PROJ(p)" "NEXT(n)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)" "KILL(k)" "Trash(t)")
          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
          (sequence "|" "OKAY(o)" "YES(y)" "NO(n)"))))

(setq org-refile-targets '((nil :maxlevel . 3)
                          (org-agenda-files :maxlevel . 1)))

(use-package! org-pomodoro)

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
