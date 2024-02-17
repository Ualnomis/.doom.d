;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one)

(setq org-directory "~/org/")

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
