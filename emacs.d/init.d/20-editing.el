;; follow symlinks to version controlled files
(setq vc-follow-symlinks t)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;;; Set tab width to 4 spaces
(setq default-tab-width 4)

;; Do *not* use tabs for indent
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)

;; enable override selection
(delete-selection-mode t)

;;; auto-insert newline at eof
(setq require-final-newline t)

;; match parenthisis
(show-paren-mode 1)

(put 'upcase-region 'disabled nil)

(put 'narrow-to-region 'disabled nil)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

; Remember position in buffers
(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package

;; Dynamic Abbreviations C-<tab>
(global-set-key (kbd "C-<tab>") 'dabbrev-expand)
(define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand)

;; Hilight the current line
(global-hl-line-mode 1)
(add-hook 'eshell-mode-hook
	  '(lambda()
	     (set (make-local-variable 'global-hl-line-mode) nil)))
(add-hook 'calendar-mode-hook
	  '(lambda()
	     (set (make-local-variable 'global-hl-line-mode) nil)))
(add-hook 'comint-mode-hook
	  '(lambda()
	     (set (make-local-variable 'global-hl-line-mode) nil)))
(add-hook 'term-mode-hook
	  '(lambda()
	     (set (make-local-variable 'global-hl-line-mode) nil)))
(add-hook 'slime-repl-mode-hook
	  '(lambda()
	     (set (make-local-variable 'global-hl-line-mode) nil)))
(add-hook 'erc-mode-hook
	  '(lambda()
	     (set (make-local-variable 'global-hl-line-mode) nil)))


; store temporary files in home directory
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))


;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
    (filename (buffer-file-name)))
    (if (not filename)
    (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
      (message "A buffer named '%s' already exists!" new-name)
    (progn
      (rename-file name new-name 1)
      (rename-buffer new-name)
      (set-visited-file-name new-name)
      (set-buffer-modified-p nil))))))