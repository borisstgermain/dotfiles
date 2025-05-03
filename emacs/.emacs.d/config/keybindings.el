;; Navigation

;; Up
(global-unset-key (kbd "C-i"))
(global-set-key (kbd "C-i") 'previous-line)

;; Down
(global-unset-key (kbd "C-k"))
(global-set-key (kbd "C-k") 'next-line)

;; Left
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'backward-char)

;; Right
(global-unset-key (kbd "C-l"))
(global-set-key (kbd "C-l") 'forward-char)

;; Forward word
(global-unset-key (kbd "M-l"))
(global-set-key (kbd "M-l") 'forward-word)

;; Backward word
(global-unset-key (kbd "M-j"))
(global-set-key (kbd "M-j") 'backward-word)

;; Beginning of line
(global-unset-key (kbd "M-J"))
(global-set-key (kbd "M-J") 'move-beginning-of-line)

;; End of line
(global-unset-key (kbd "M-L"))
(global-set-key (kbd "M-L") 'move-end-of-line)

;; Next page
(global-unset-key (kbd "M-k"))
(global-set-key (kbd "M-k") 'scroll-up-command)

;; Prev page
(global-unset-key (kbd "M-i"))
(global-set-key (kbd "M-i") 'scroll-down-command)

;; End of buffer
(global-unset-key (kbd "M-K"))
(global-set-key (kbd "M-K") 'end-of-buffer)

;; Beginning of buffer
(global-unset-key (kbd "M-I"))
(global-set-key (kbd "M-I") 'beginning-of-buffer)

;; Beginnig of bracket
(global-unset-key (kbd "C-o"))
(global-set-key (kbd "C-o") 'forward-sexp)

;; End of bracket
(global-unset-key (kbd "C-u"))
(global-set-key (kbd "C-u") 'backward-sexp)

;; Next sentence
(global-unset-key (kbd "M-o"))
(global-set-key (kbd "M-o") 'forward-sentence)

;; Prev sentence
(global-unset-key (kbd "M-u"))
(global-set-key (kbd "M-u") 'backward-sentence)

;; End of paragraph
(global-unset-key (kbd "M-O"))
(global-set-key (kbd "M-O") 'forward-paragraph)

;; Beginning of paragraph
(global-unset-key (kbd "M-U"))
(global-set-key (kbd "M-U") 'backward-paragraph)
