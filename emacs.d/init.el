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

;;(add-to-list 'load-path "~/.emacs.d/tuareg-2.0.6/")
;;(load "~/.emacs.d/tuareg-2.0.6/tuareg-site-file")

;;(load-file "~/.emacs.d/htmlize.el")

(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;(load-file "~/.emacs.d/python.el")
;;(require 'python)
;;(add-to-list 'auto-mode-alist '("\\.py\\" . python))

;;http://emacswiki.org/emacs/MultipleModes
(load-file "~/.emacs.d/multi-web-mode.el")
;;(add-to-list 'load-path "~/.emacs.d/")
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


;;; new macro declare-abbrevs -- similar to define-abbrev-table
(require 'cl)
(defvar my-abbrev-tables nil)
(defun my-abbrev-hook ()
  (let ((def (assoc (symbol-name last-abbrev) my-abbrev-tables)))
    (when def
      (execute-kbd-macro (cdr def)))
    t))
(put 'my-abbrev-hook 'no-self-insert t)
(defmacro declare-abbrevs (table abbrevs)
  (if (consp table)
      `(progn ,@(loop for tab in table
		      collect `(declare-abbrevs ,tab ,abbrevs)))
    `(progn
       ,@(loop for abbr in abbrevs
	       do (when (third abbr)
		    (push (cons (first abbr) (read-kbd-macro (third abbr)))
			  my-abbrev-tables))
	       collect `(define-abbrev ,table
			  ,(first abbr) ,(second abbr) ,(and (third abbr)
							     ''my-abbrev-hook))))))
(put 'declare-abbrevs 'lisp-indent-function 2)

    ;;; sample abbrev definitions
(eval-after-load "cc-mode"
  '(declare-abbrevs (c-mode-abbrev-table c++-mode-abbrev-table)
    (("INC"	"#include ")
     ("DATE"	"" "(my_truc)")
     ("DOC"	"/*!\n * \\brief \n * \n */" "")
     ("DOCFU"	"/*!\n * \\brief \n * \\param \n * \\return \n */" "")
     ("MAIN"	"#include <sys/select.h>\n#include <sys/time.h>\n#include <sys/types.h>\n#include <stdio.h>\n#include <stdlib.h>\n#include <unistd.h>\n#include <string.h>\n\nint	main(int ac, char **av)\n{\n  \n  return (0);\n}" "C-2 C-p")
     ("SEP"	"
/* ******************************************** */
/*						*/
/* ******************************************** */\n" "C-2 C-p")
     ("pr"	"printf(\"\\n\");" "C-5 C-b")
     ("COUT"	"std::cout <<  << std::endl;" "C-9 C-b C-5 C-b")
     ("CERR"	"std::cerr <<  << std::endl;" "C-9 C-b C-5 C-b")
     )))

(eval-after-load "jde"
  '(declare-abbrevs (java-mode-abbrev-table jde-mode-abbrev-table)
    (("pp"   "System.out.print ()" "C-b")
     ("psvm" "public static void main(String[] args) {\n\n}" "C-p TAB C-h")
     ("pl"   "System.out.println ()" "C-b")
     ("pr"   "System.out.print ()" "C-b"))))

;; ***************************************
;;				ALIGNEMENT
;; ***************************************
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
