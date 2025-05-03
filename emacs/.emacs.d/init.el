(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq auto-save-default nil)

;; Загрузка кастомных модулей
(load-file (expand-file-name "config/keybindings.el" user-emacs-directory))
