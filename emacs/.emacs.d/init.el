(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq auto-save-default nil)

;; Увеличить лимит памяти
(setq gc-cons-threshold (* 50 1000 1000))

;; Загрузка кастомных модулей
(load-file (expand-file-name "config/keybindings.el" user-emacs-directory))
