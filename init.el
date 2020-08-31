;; Add ./lisp directory to search path
;;
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(package-initialize)

(require 'init-misc)
(require 'init-utils)
(require 'init-elpa)
(require 'scope-mode)
(require 'smooth-scrolling)
(require 'compile)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "31a01668c84d03862a970c471edbd377b2430868eccf5e8a9aec6831f1a0908d" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" default)))
 '(package-selected-packages
   (quote
    (websocket smartparens seq request pkg-info magit let-alist fullframe color-theme-solarized color-theme-monokai auto-complete)))
 '(py-split-windows-on-execute-function (quote split-window-horizontally)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
