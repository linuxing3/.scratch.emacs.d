(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (embark-define-keymap embark-file-map
    ("d" delete-file)
    ("r" rename-file)
    ("c" copy-file))
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package consult)

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(add-to-list 'marginalia-prompt-categories '("tab by name" . tab))
;; 启动命令
(defun my-select-tab-by-name (tab)
  (interactive
   (list
    (let ((tab-list (or (mapcar #'(lambda (tab) (cdr (assq 'name tab)))
                                (tab-bar-tabs))
                        (user-error "No tabs found"))))
      (consult--read tab-list
                     :prompt "Tabs: "
                     :category 'tab))))
  (tab-bar-select-tab-by-name tab))

;; 添加标签行为
(embark-define-keymap embark-tab-actions
  "Keymap for actions for tab-bar tabs (when mentioned by name)."
  ("s" tab-bar-select-tab-by-name)
  ("r" tab-bar-rename-tab-by-name)
  ("k" tab-bar-close-tab-by-name))

(add-to-list 'embark-keymap-alist '(tab . embark-tab-actions))

;; 关闭前提醒
(add-to-list 'embark-allow-edit-actions 'tab-bar-close-tab-by-name)
(defun my-confirm-close-tab-by-name (tab)
  (interactive "sTab to close: ")
  (when (y-or-n-p (format "Close tab '%s'? " tab))
    (tab-bar-close-tab-by-name tab)))

(defun my-short-wikipedia-link ()
  "Target a link at point of the form wikipedia:Page_Name."
  (save-excursion
    (let* ((beg (progn (skip-chars-backward "[:alnum:]_:") (point)))
           (end (progn (skip-chars-forward "[:alnum:]_:") (point)))
           (str (buffer-substring-no-properties beg end)))
      (save-match-data
        (when (string-match "wikipedia:\\([[:alnum:]_]+\\)" str)
          `(url 
            (format "https://en.wikipedia.org/wiki/%s" (match-string 1 str))
            ,beg . ,end))))))

(add-to-list 'embark-target-finders 'my-short-wikipedia-link)
