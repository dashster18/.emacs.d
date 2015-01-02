;;
;; Marmalade 
;;
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;
;; Melpa
;;
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;
;; Haskell indentation mode
;; `haskell-indentation', Kristof Bastiaensen
;; Intelligent semi-automatic indentation, mark two. How to enable:
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(haskell-mode-hook (quote (turn-on-haskell-indentation)))
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;;
;; IDO mode
;;
(require 'ido)
    (ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

;;
;; Create new buffers IDO
;;
(setq ido-create-new-buffer 'always)

;;
;; Auto complete everywharrr
;;
(require 'auto-complete)
(global-auto-complete-mode t)

;;
;; Line numbers
;;
(global-linum-mode t)
(setq column-number-mode t)

;; M-x == C-x C-m
(global-set-key "\C-x\C-m" 'execute-extended-command)

;;
;; No moar backspaces
;;
(defmacro define-2bind-transient-mode (funname cmd-mark-active
                                                   cmd-mark-no-active)
  `(defun ,funname ()
     (interactive)
     (if mark-active
       (call-interactively ,cmd-mark-active)
       (call-interactively ,cmd-mark-no-active))))

(define-2bind-transient-mode
  backward-kill-word-or-kill-region
  'kill-region
  'backward-kill-word)

(global-set-key "\C-w"     'backward-kill-word-or-kill-region)


;;
;; Strip the UI clean
;;
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;
;; Smooth scrolling
;;
(setq scroll-step 1) ;; keyboard scroll one line at a time

;;
;; Turn off line wrapping
;;
(setq-default truncate-lines t)

;;
;; Open .h files in C++ mode
;;
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;
;; Move backup files in a temp folder
;;
(setq backup-directory-alist
`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
`((".*" ,temporary-file-directory t)))

;;
;; Deleted items are sent to the Recycle Bin
;;
(setq delete-by-moving-to-trash t)

;;
;; Use Octave mode for all .m files
;;
(autoload 'octave-mode "octave-mod" nil t)
          (setq auto-mode-alist
                (cons '("\\.m$" . octave-mode) auto-mode-alist))

;;
;; Auto indent and parenthesis/brace matching
;;
(electric-pair-mode t)

;;
;; Save all backups in one place
;;
(setq backup-directory-alist `(("." . "~/.saves")))

;;
;; Turns off annoying IRC messages
;;
(setq erc-hide-list '("JOIN" "PART" "QUIT"))

;;
;; Remove splash screen
;;
(setq inhibit-startup-message t
  inhibit-startup-echo-area-message t) 

;;
;; Adds newline at end of buffer with C-n
;;
(setq next-line-add-newlines t)

;;
;; Show tooltips in the echo area
;;
(tooltip-mode -1)
(setq tooltip-use-echo-area t)

;;
;; Maximize Emacs at startup on Windows
;;
(defun maximize-frame ()
  "Maximizes the active frame in Windows"
  (interactive)
  ;; Send a `WM_SYSCOMMAND' message to the active frame with the
  ;; `SC_MAXIMIZE' parameter.
  (when (eq system-type 'windows-nt)
    (w32-send-sys-command 61488)))
(add-hook 'window-setup-hook 'maximize-frame t)


;;
;; Navigation between windows
;;

(defun frame-bck()
  (interactive)
  (other-window -1)
)

(global-set-key (kbd "M-o") 'other-window)    ; move to next window
(global-set-key (kbd "M-O") 'frame-bck)     ; move to previous window
(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

;;
;; Quick compile
;;
(global-set-key (kbd "C-c C-j") 'compile)

;;
;; C++ mode Visual Studio style
;;
(defun my-c-mode-common-hook ()
 ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
 (c-set-offset 'substatement-open 0)
 ;; other customizations can go here

 (setq c++-tab-always-indent t)
 (setq c-basic-offset 4)                  ;; Default is 2
 (setq c-indent-level 4)                  ;; Default is 2

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 (setq tab-width 4)
 (setq indent-tabs-mode t)  ; use spaces only if nil
 )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
;; Change highlight color
;;
;; (set-face-attribute 'region nil :background "#ff009a")

;;
;; org mode stuff
;;
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-agenda-files (list "~/org/tasks.org"))

;; 
;; Indent whole buffer 
;; 
(defun indent-buffer ()
  (interactive)
  (save-excursion 
    (indent-region (point-min) (point-max) nil)))

(global-set-key "\C-x\C-j" 'indent-buffer)
(put 'narrow-to-region 'disabled nil)

;;
;; Transparency
;; 
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
(set-frame-parameter (selected-frame) 'alpha '(91 91))
(add-to-list 'default-frame-alist '(alpha 91 91))
