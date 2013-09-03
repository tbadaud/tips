;; M-x ido-mode (disable/enable autoComplete (ex C-x C-f)
;; C-k (kill fichier)
;; C-w (kill select)
;; M-w (cpy select)

(setq user-nickname "Thomas Badaud")

(custom-set-variables
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(inhibit-startup-screen t)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
;; '(blink-cursor-mode nil))
)

(global-set-key [f5] 'goto-line)

(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

; Corrige Ctrl+left/right
(global-set-key "\M-OC" 'backward-word)
(global-set-key "\M-OD" 'forward-word)

;;(normal-erase-is-backspace-mode)
(setq-default indent-tabs-mode nil)
;;(setq-default tab-width 2)
;;(setq-default indent-for-tab-command 2)
;;(setq-default c-basic-offset 2)
;;(add-hook 'python-mode-hook '(lambda ()
;; (setq python-indent 2)))
;;(setq-default js-indent-level 2)

;; chmod +x si shebang
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; (load-file "~/.emacs.d/codeworker/badaud.el")
;; (add-to-list 'load-path "~/.emacs.d/codeworker/")
;; (require 'codeworker)

;;(add-to-list 'load-path "~/.emacs.d/")

;;(load-file "~/.emacs.d/htmlize.el")

(add-to-list 'load-path "~/.emacs.d/tuareg-2.0.6/")
(load "~/.emacs.d/tuareg-2.0.6/tuareg-site-file")

(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;http://emacswiki.org/emacs/MultipleModes
(load-file "~/.emacs.d/multi-web-mode.el")
;;(require '~/.emacs.d/multi-web-mode.el)
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
		  (js-mode "<script[^>]*>" "</script>")
		  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist)) 
(autoload 'tuareg-mode "tuareg" "Mode majeur pour éditer du code Caml" t) 
(autoload 'camldebug "camldebug" "Exécuter le débogueur Caml" t)

(add-hook 'auto-complete-mode-hook (lambda ()
 				     (setq ac-sources (remq 'ac-source-filename ac-sources)))
 	  t)


(define-abbrev-table 'c-mode-abbrev-table
  '(
    ("INC" "#include")
    ("pr" "printf(\"\\n\");" (lambda ()
                               (backward-char 5)))
))

(define-abbrev-table 'c++-mode-abbrev-table
  '(
    ("COUT" "std::cout << << std::end;" (lambda () (backward-char 13)))
    ("CERR" "std::cerr << << std::end;" (lambda () (backward-char 13)))
))

;; Alignement
(setq align-indent-before-aligning t ;indenter avant d'aligner
      align-to-tab-stop          t ;aligner sur des tabulations style Epitech
      ;;align-to-tab-stop nil
      )
(defun align-region-or-current ()
  "If a region is active align the region, otherwise align at point"
  (interactive)
  (if mark-active
      (align (region-beginning) (region-end))
    (align-current)
    )
  )

;; Align with keyboard !
(global-set-key (kbd "C-c a") 'align-region-or-current)
(global-set-key (kbd "C-c A") 'align-regexp)
