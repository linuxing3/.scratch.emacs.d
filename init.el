  ;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
  ;;       in Emacs and init.el will be generated automatically!

  ;; You will most likely need to adjust this font size for your system!
  (defvar efs/default-font-size 180)
  (defvar efs/default-variable-font-size 180)

  ;; Make frame transparency overridable
  (defvar efs/frame-transparency '(90 . 90))

    ;;(setq locale-coding-system 'utf-8)
    ;;(set-default-coding-systems 'utf-8)

    (prefer-coding-system 'utf-8)
    (set-language-environment 'utf-8)
    (set-buffer-file-coding-system 'utf-8)
    ;; (set-clipboard-coding-system 'utf-8)
    ;; (set-file-name-coding-system 'utf-8)
    ;; (set-keyboard-coding-system 'utf-8)
    ;; (set-terminal-coding-system 'utf-8)
    ;; (set-selection-coding-system 'utf-8)
    (setq org-export-coding-system 'utf-8)

  ;; The default is 800 kilobytes.  Measured in bytes.
  (setq gc-cons-threshold (* 50 1000 1000))

  (defun efs/display-startup-time ()
    (message "Emacs loaded in %s with %d garbage collections."
             (format "%.2f seconds"
                     (float-time
                       (time-subtract after-init-time before-init-time)))
             gcs-done))

  (add-hook 'emacs-startup-hook #'efs/display-startup-time)

  ;; Initialize package sources
  (require 'package)

  ;; (setq package-archives '(("melpa" . "https://melpa.org/packages/")
  ;;                          ("org" . "https://orgmode.org/elpa/")
  ;;                          ("elpa" . "https://elpa.gnu.org/packages/")))
  ;; ------ 腾讯源 ------
  (setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
  			 ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
  			 ("melpa-stable" . "http://mirrors.cloud.tencent.com/elpa/melpa-stable/")
  			 ("org" . "http://mirrors.cloud.tencent.com/elpa/org/")))

  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents))

    ;; Initialize use-package on non-Linux platforms
  (unless (package-installed-p 'use-package)
    (package-install 'use-package))

  (require 'use-package)
  (setq use-package-always-ensure t)

  (use-package auto-package-update
    :custom
    (auto-package-update-interval 30)
    (auto-package-update-prompt-before-update t)
    (auto-package-update-hide-results t)
    :config
    (auto-package-update-maybe)
    (auto-package-update-at-time "09:00"))

  (add-to-list 'load-path "~/.evil.emacs.d/core")
  (add-to-list 'load-path "~/.evil.emacs.d/modules")
  (require 'core-lib)
  (require 'core-helper)

  ;; NOTE: If you want to move everything out of the ~/.emacs.d folder
  ;; reliably, set `user-emacs-directory` before loading no-littering!
  ;(setq user-emacs-directory "~/.cache/emacs")

  (use-package no-littering)

  ;; no-littering doesn't set this by default so we must place
  ;; auto save files in the same path as it uses for sessions
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

  (setq inhibit-startup-message t)
  (setq inhibit-startup-screen t)
  (setq inhibit-default-init t)
  (setq inhibit-startup-echo-area-message user-login-name)
  (setq initial-scratch-message ";; Happy Hacking with emacs from scratch")

  (setq show-paren-delay 0)
  (setq dired-dwim-target t)

  ;; Make modern look
  (show-paren-mode  1)
  (tool-bar-mode -1)          ; Disable the toolbar
  (tooltip-mode -1)           ; Disable tooltips
  (menu-bar-mode -1)            ; Disable the menu bar

  (when (display-graphic-p)
    (progn
        (scroll-bar-mode -1)        ; Disable visible scrollbar
        (set-fringe-mode 10)        ; Give some breathing room
      ))

  ;; Set up the visible bell
  (setq visible-bell t)

  (column-number-mode)
  (global-display-line-numbers-mode t)

  (fset 'yes-or-no-p 'y-or-n-p)
  ;; Set frame transparency
  (set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
  (add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))

  ;; Disable line numbers for some modes
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  shell-mode-hook
                  treemacs-mode-hook
                  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))

(add-to-list 'default-frame-alist
            '(font . "Droid Sans Mono-16:antialias=standard"))

(set-face-attribute 'default nil :font "Droid Sans Mono" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Droid Sans Mono" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-variable-font-size :weight 'regular)

;; (set-fontset-font "fontset-default" 'han "Microsoft YaHei UI")
(defun +modern-ui-chinese-h ()
  "Set Font for chinese language"
  (set-fontset-font
   t
   'han
   (cond
    ((string-equal system-type "windows-nt")
     (cond
      ((member "Microsoft YaHei UI" (font-family-list)) "Microsoft YaHei UI")
      ))
    ((string-equal system-type "darwin")
     (cond
      ((member "Hei" (font-family-list)) "Hei")
      ((member "Heiti SC" (font-family-list)) "Heiti SC")
      ((member "Heiti TC" (font-family-list)) "Heiti TC")))
    ((string-equal system-type "gnu/linux")
     (cond
      ((member "WenQuanYi Micro Hei" (font-family-list)) "WenQuanYi Micro Hei"))))))

(when (display-graphic-p) (+modern-ui-chinese-h))

  ;; Make ESC quit prompts
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  (use-package general
    :after evil
    :config
    (general-create-definer efs/leader-keys
      :keymaps '(normal insert visual emacs)
      :prefix "SPC"
      :global-prefix "C-SPC")

    (efs/leader-keys
      "t"  '(:ignore t :which-key "toggles")
      "tt" '(counsel-load-theme :which-key "choose theme")
      "fde" '(lambda () (interactive) (find-file (expand-file-name "~/emacs-repos/emacs-from-scratch/Emacs.org")))))

  (use-package evil
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-C-i-jump nil)
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state) ;; insert mode escape to normal mode
    (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join) ;; backward delete

    ;; Use visual line motions even outside of visual-line-mode buffers
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

    (evil-set-initial-state 'messages-buffer-mode 'normal)
    (evil-set-initial-state 'dashboard-mode 'normal))

  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

  (use-package command-log-mode
    :commands command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

  (use-package helpful
    :commands (helpful-callable helpful-variable helpful-command helpful-key)
    :custom
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
    :bind
    ([remap describe-function] . counsel-describe-function)
    ([remap describe-command] . helpful-command)
    ([remap describe-variable] . counsel-describe-variable)
    ([remap describe-key] . helpful-key))

  (use-package hydra
    :defer t)

  (defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t))

  (efs/leader-keys
    "cs" '(hydra-text-scale/body :which-key "scale text"))

  (use-package which-key
    :defer 0
    :diminish which-key-mode
    :config
    (which-key-mode)
    (setq which-key-idle-delay 1))

(require 'core-default)
(linuxing3/better-ivy-h) ;; use ivy to complete anything, vertico is another options 
(require 'editor+embark) ;; enable embark tool
(require 'editor+consult) ;; enable consult than swiper

  (use-package term
    :commands term
    :config
    (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
    ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

    ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
    (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

  (use-package eterm-256color
    :hook (term-mode . eterm-256color-mode))

  (use-package vterm
    :commands vterm
    :config
    (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
    ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
    (setq vterm-max-scrollback 10000))

  (when (eq system-type 'windows-nt)
    (setq explicit-shell-file-name "powershell.exe")
    (setq explicit-powershell.exe-args '()))

  (defun efs/configure-eshell ()
    ;; Save command history when commands are entered
    (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

    ;; Truncate buffer for performance
    (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

    ;; Bind some useful keys for evil-mode
    (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
    (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
    (evil-normalize-keymaps)

    (setq eshell-history-size         10000
          eshell-buffer-maximum-lines 10000
          eshell-hist-ignoredups t
          eshell-scroll-to-bottom-on-input t))

  (use-package eshell-git-prompt
    :after eshell)

  (use-package eshell
    :hook (eshell-first-time-mode . efs/configure-eshell)
    :config

    (with-eval-after-load 'esh-opt
      (setq eshell-destroy-buffer-when-process-dies t)
      (setq eshell-visual-commands '("htop" "zsh" "vim")))

    (eshell-git-prompt-use-theme 'powerline))

  (use-package dired
    :ensure nil
    :commands (dired dired-jump)
    :bind (("C-x C-j" . dired-jump))
    :custom ((dired-listing-switches "-agho --group-directories-first"))
    :config
    (setq dired-dwim-target t)
    (defun linuxing3/dired-mode-setup ()(dired-hide-details-mode 1))
    (add-hook 'dired-mode-hook 'linuxing3/dired-mode-setup)
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer))

  (use-package dired-single
    :commands (dired dired-jump))

  (use-package all-the-icons-dired
    :hook (dired-mode . all-the-icons-dired-mode))

  (use-package dired-open
    :commands (dired dired-jump)
    :config
    ;; Doesn't work as expected!
    ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
    (setq dired-open-extensions '(("png" . "feh")
                                  ("mkv" . "mpv"))))

  (use-package dired-hide-dotfiles
    :hook (dired-mode . dired-hide-dotfiles-mode)
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "H" 'dired-hide-dotfiles-mode))

  (use-package openwith
    :config
    (when (require 'openwith nil 'noerror)
      (setq openwith-associations
            (list
             (list (openwith-make-extension-regexp
                    '("mpg" "mpeg" "mp3" "mp4"
                      "avi" "wmv" "wav" "mov" "flv"
                      "ogm" "ogg" "mkv"))
                   "mpv"
                   '(file))
             (list (openwith-make-extension-regexp
                    '("xbm" "pbm" "pgm" "ppm" "pnm"
                      "png" "gif" "bmp" "tif" "jpeg" "jpg"))
                   "sxiv"
                   '(file))
             (list (openwith-make-extension-regexp
                    '("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
                   "libreoffice"
                   '(file))
             '("\\.lyx" "lyx" (file))
             '("\\.chm" "kchmviewer" (file))
             '("\\.pdf" "zathura" (file))
             (list (openwith-make-extension-regexp
                    '("ps" "ps.gz" "dvi"))
                   "chromium"
                   '(file))
             ))
      (openwith-mode 1)))

(require 'iimage)
(autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
(autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)
(add-to-list 'iimage-mode-image-regex-alist '("@startuml\s+\\(.+\\)" . 1))


(use-package plantuml-mode
  :ensure t
  :commands plantuml-download-jar
  :config
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
  (add-to-list
   'org-src-lang-modes '("plantuml" . plantuml))
  ;; Rendering plantuml
  (defun plantuml-render-buffer ()
    (interactive)
    (message "PLANTUML Start rendering")
    (shell-command (concat "java -jar " plantuml-jar-path " "
                           buffer-file-name))
    (message (concat "PLANTUML Rendered:  " (buffer-name))))

  ;; Image reloading
  (defun reload-image-at-point ()
    (interactive)
    (message "reloading image at point in the current buffer...")
    (image-refresh (get-text-property (point) 'display)))

  ;; Image resizing and reloading
  (defun resize-image-at-point ()
    (interactive)
    (message "resizing image at point in the current buffer123...")
    (let* ((image-spec (get-text-property (point) 'display))
           (file (cadr (member :file image-spec))))
      (message (concat "resizing image..." file))
      (shell-command (format "convert -resize %d %s %s "
                             (* (window-width (selected-window)) (frame-char-width))
                             file file))
      (reload-image-at-point)))
  :init
  (setq org-ditaa-jar-path "~/.dotfiles/tools/ditaa.jar")
  (setq plantuml-default-exec-mode 'jar) ;; jar使用本地jar包生成图片
  (setq plantuml-jar-path "~/.dotfiles/tools/plantuml.jar")
  (setq org-plantuml-jar-path plantuml-jar-path))

(use-package flycheck-plantuml
  :ensure t
  :after plantuml-mode
  :config (flycheck-plantuml-setup))

(use-package mpv)

(require 'module-remote)

  (defun efs/org-font-setup ()
    ;; Replace list hyphen with dot
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    ;; Set faces for heading levels
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
    (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
    (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
    (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

  (defun efs/org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode 1)
    (visual-line-mode 1))

  (use-package org
    :pin org
    :commands (org-capture org-agenda)
    :hook (org-mode . efs/org-mode-setup)
    :config
    (setq org-ellipsis " ▾")

    (setq org-agenda-start-with-log-mode t)
    (setq org-log-done 'time)
    (setq org-log-into-drawer t)

    (require 'org-habit)
    (add-to-list 'org-modules 'org-habit)
    (setq org-habit-graph-column 60)

    ;; Save Org buffers after refiling!
    (advice-add 'org-refile :after 'org-save-all-org-buffers)

    (define-key global-map (kbd "C-c j")
      (lambda () (interactive) (org-capture nil "xh")))

    (efs/org-font-setup))

  (use-package org-bullets
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

  (defun efs/org-mode-visual-fill ()
    (setq visual-fill-column-width 100
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1))

  (use-package visual-fill-column
    :hook (org-mode . efs/org-mode-visual-fill))

  (with-eval-after-load 'org
    (org-babel-do-load-languages
        'org-babel-load-languages
        '((emacs-lisp . t)
        (python . t)))

    (push '("conf-unix" . conf-unix) org-src-lang-modes))

  (with-eval-after-load 'org
    ;; This is needed as of Org 9.2
    (require 'org-tempo)

    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python")))

  ;; Automatically tangle our Emacs.org config file when we save it
  (defun efs/org-babel-tangle-config ()
    (when (string-equal (file-name-directory (buffer-file-name))
                        (expand-file-name user-emacs-directory))
      ;; Dynamic scoping to the rescue
      (let ((org-confirm-babel-evaluate nil))
        (org-babel-tangle))))

  (add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

  (require 'module-org)

(setq bookmark-default-file "~/.dotfiles/custom/emacs/bookmarks-default.el")
(setq custom-theme-directory "~/.dotfiles/custom/emacs/themes/")
(setq user-full-name "Xing Wenju"
      user-mail-address "linuxing3@qq.com")
(setq browse-url-browser-function 'browse-url-chromium)

  (require 'core-keybinds)

  ;; Make gc pauses faster by decreasing the threshold.
  (setq gc-cons-threshold (* 2 1000 1000))
