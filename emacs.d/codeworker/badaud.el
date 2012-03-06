(require 'cl)
(require 'ido)

(add-to-list 'load-path "/home/badaud_t/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                           (auto-complete-mode 1))))

(setq el-get-sources
      '(el-get
        (:name auto-complete
	       :after (lambda ()
			(real-global-auto-complete-mode t)))))
(el-get)
