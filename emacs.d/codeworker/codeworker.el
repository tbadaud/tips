(require 'cl)
(require 'ido)
(require 'codeworker-completion nil t)

;; Usage:
;; (add-to-list 'load-path "le/repertoire/de/codeworker.el/")
;; (require 'codeworker)

(unless (string= user-nickname "Guillaume Papin")
  (ido-mode 1)
  ;; Dot directory first for `ido-find-file', enter to go in dired mode
  (setq ido-use-filename-at-point nil)
  ;; (setq ido-show-dot-for-dired t)
  (setq ido-enable-flex-matching t)
  ;; Allow the same buffer to be open in different frames
  (setq ido-default-buffer-method 'selected-window)
  (ido-mode 1)

  (setq browse-url-generic-program "firefox")
;;  (setq browse-url-generic-program "google-chrome")
  (setq browse-url-browser-function '(("^file:" . browse-file-url)
                                      ("."      . browse-url-generic))))

(defvar codeworker-completion-alist nil
  "An alist of completion (\"function . url\")")

(defvar codeworker-completion-list nil)

(defun codeworker-decode-identifier (string)
  (loop with str = string
        for pair in '(("&nbsp;" . " ")
                      ("&lt;"   . "<")
                      ("&gt;"   . ">")
                      ("&amp;"  . "&"))
        do (setq str (replace-regexp-in-string (car pair) (cdr pair) str))
        finally return str))

(defun get-codeworker-completions ()
  (interactive)
  (unless codeworker-completion-alist
    (let (
          ;; (documentation (url-retrieve-synchronously
          ;;                 "http://codeworker.free.fr/Documentation.html"))
          ;; (documentation-url
          ;;  "http://codeworker.free.fr/manual_The_scripting_language.html#")

          (manual-idx (url-retrieve-synchronously
                       "http://codeworker.free.fr/manual__INDEX.html"))
          (manual-url-prefix
           "http://codeworker.free.fr/manual_.html"))

      ;; (save-excursion
      ;;   (set-buffer documentation)
      ;;   (goto-char (point-min))
      ;;   (while (re-search-forward "<CODE>\\(.+\\)</CODE>" nil t)
      ;;     (add-to-list 'codeworker-completion-alist (cons (match-string 1) (match-string 1))))
      ;;   (kill-buffer (current-buffer)))

      ;; #_appendedFile
      ;;
      ;; Url
      ;; http://codeworker.free.fr/manual__INDEX.html
      ;; match group:
      ;; 1 -> url
      ;; 2 -> identifier
      (save-excursion
        (set-buffer manual-idx)
        (goto-char (point-min))
        (while (re-search-forward "[^;]<a\\s-+href=\"manual_\\.html\\([^\"]+\\)\"[^>]+>\\([^<]+\\)" nil t)
          (let ((identifier (codeworker-decode-identifier (match-string 2))))
            (unless (assoc identifier codeworker-completion-alist) ;pas de duplicata
              (add-to-list 'codeworker-completion-alist
                           (cons identifier ;identifier
                                 (concat manual-url-prefix (match-string 1))))))) ;url
        (kill-buffer (current-buffer)))))
  (setq codeworker-completion-list (mapcar 'car codeworker-completion-alist))
  codeworker-completion-alist)

(defun codeworker-completing-read (prompt alist prefix)
  (let ((completion (ido-completing-read
                     prompt
                     (mapcar 'car alist)
                     nil ;ign
                     t ;require match
                     prefix)))
    (cdr (assoc completion alist))))

(defun codeworker-show-doc (arg)
  (interactive "P")
  (let ((url  (codeworker-completing-read "CodeWorker function: "
                                          (get-codeworker-completions)
                                          (if (null arg)(current-word)))))
    (browse-url url)))

(global-set-key [f7] 'codeworker-show-doc)

(add-to-list 'auto-mode-alist (cons "\\.cws" 'c++-mode))
(add-to-list 'auto-mode-alist (cons "\\.cwp" 'antlr-mode))
(add-to-list 'auto-mode-alist (cons "\\.k[ch]" 'objc-mode))

(add-hook 'antlr-mode 'auto-complete-mode)

(ac-define-source codeworker
  '((init . get-codeworker-completions)
    (candidates . codeworker-completion-list)
    (requires . 2)
    (symbol . "s")))

(defconst codeworker-kooc-keywords
  (cons
   (regexp-opt
    '("@import"
      "@module"
      "@implementation") ;;'words
    )
   font-lock-keyword-face))

(add-hook 'find-file-hook
          (lambda ()
            (if (or (string= (file-name-extension (buffer-file-name)) "cws")
                    (string= (file-name-extension (buffer-file-name)) "cwp"))
                (add-to-list 'ac-sources 'ac-source-codeworker))
            ;; (if (or (string= (file-name-extension (buffer-file-name)) "kc")
            ;;         (string= (file-name-extension (buffer-file-name)) "kh"))
            ;;     (font-lock-add-keywords nil (list
            ;;                                  codeworker-kooc-keywords)))
            ))

(font-lock-add-keywords 'objc-mode (list codeworker-kooc-keywords))

(require 'compile)
;; http://www.emacswiki.org/emacs/CreatingYourOwnCompileErrorRegexp
(add-to-list 'compilation-error-regexp-alist 'codeworker)
(add-to-list 'compilation-error-regexp-alist-alist
             '(codeworker
               "\\(\\(?:.*\\.cw[sp]\\)\\)(\\([[:digit:]]+\\)\\(?:,\\([[:digit:]]+\\)\\)?):"
               1 2 3))

;; (let ((buffer (get-buffer-create "/tmp/codeworker-functions.el")))
;;   (with-current-buffer buffer
;;     (erase-buffer)
;;     (insert "(setq codeworker-completion-alist '(")
;;     (dolist (function (delete-dups functions))
;;       (insert (format "\"%s\" " function)))
;;     (insert ")")))))

(provide 'codeworker)
