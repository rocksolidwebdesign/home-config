;;
;; Cut C-w
;; Copy A-w
;; Paste C-y
;;
;; Select, then
;; C-x r t
;;   then type to enter at beginnin of rectangle
;; C-x r y
;;   yank the rectangular selection
;; C-x r k
;;   cut the rectangular selection
;; Comment M-;
;; Uncomment C-u M-;

(add-to-list 'load-path "~/.emacs.d/plugins/dirtree")
(require 'dirtree)


(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
(require 'find-file-in-project)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes (quote ("71efabb175ea1cf5c9768f10dad62bb2606f41d110152f4ace675325d28df8bd" default)))
 '(ido-everywhere t)
 '(inhibit-default-init t)
 '(truncate-lines t))
 '(ido-enable-prefix nil)
 '(ido-enable-flex-matching t)
 '(ido-auto-merge-work-directories-length nil)
 '(ido-create-new-buffer 'always)
 '(ido-use-filename-at-point 'guess)
 '(ido-use-virtual-buffers t)
 '(ido-handle-duplicate-virtual-buffers 2)
 '(ido-max-prospects 10)
 '(ffip-limit 4096)
 '(ffip-patterns (append `("*.tpl" "*.php") ffip-patterns))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 88 :width normal)))))

(ido-mode t)

(defmacro allow-line-as-region-for-function (orig-function)
  `(defun ,(intern (concat (symbol-name orig-function) "-or-line"))
     ()
     ,(format "Like `%s', but acts on the current line if mark is not active."
              orig-function)
     (interactive)
     (if mark-active
         (call-interactively (function ,orig-function))
       (save-excursion
       ;; define a region (temporarily) -- so any C-u prefixes etc. are preserved.
         (beginning-of-line)
         (set-mark (point))
         (end-of-line)
         (call-interactively (function ,orig-function))))))

(unless (fboundp 'comment-or-uncomment-region-or-line)
  (allow-line-as-region-for-function comment-or-uncomment-region))

;;(global-set-key (kbd "s-/") 'comment-or-uncomment-region)

