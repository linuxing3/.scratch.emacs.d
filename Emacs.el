  (use-package lsp-ivy
    ;;:load-path "./localelpa/lsp-ivy"
    :after lsp)

  (use-package python-mode
    :ensure t
    :hook (python-mode . lsp-deferred)
    :custom
    ;; NOTE: Set these if Python 3 is called "python3" on your system!
    (python-shell-interpreter "python3")
    (dap-python-executable "python3")
    (dap-python-debugger 'debugpy)
    :config
    (require 'dap-python)
    (dap-register-debug-template "My App"
        (list :type "python"
                :args "-i"
                :cwd nil
                :env '(("DEBUG" . "1"))
                :target-module (expand-file-name "~/src/myapp/.env/bin/myapp")
                :request "launch"
                :name "My App")))

  (use-package company
    ;; :after lsp-mode
    ;; :hook (lsp-mode . company-mode)
    :bind (:map company-active-map
           ("TAB" . company-complete-selection)
           ("<tab>" . company-complete-selection)
           ("S-TAB" . company-complete-select-previous)
           ("<backtab>" . company-complete-select-previous))
          (:map lsp-mode-map
           ("<tab>" . company-indent-or-complete-common))
    :config
    (global-company-mode 1)
    (define-key company-mode-map [remap indent-for-tab-command] 'company-indent-for-tab-command)
    :custom
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.0))

  (use-package company-box
    :hook (company-mode . company-box-mode))
