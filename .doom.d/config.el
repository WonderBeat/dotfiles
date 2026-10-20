;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "wonderbeat"
      user-mail-address "wombat@gmail.com")

(setq doom-font (font-spec :family "Monaspace Neon" :size 13 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "MesloLGL Nerd Font" :size 14)
      doom-theme 'doom-pine
      org-directory "~/org/"
      display-line-numbers-type t
      confirm-kill-emacs nil)

(setq-default
 delete-by-moving-to-trash t
 window-combination-resize t   ; new windows take space from all siblings
 x-stretch-cursor t)

(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…"
      password-cache-expiry nil
      scroll-margin 2)

(display-time-mode 1)
(windmove-default-keybindings 'meta)  ; Opt+arrows move between windows
(global-subword-mode 1)

(after! lsp-mode
  (dolist (dir '("[/\\\\]build\\'" "[/\\\\]gradle\\'" "[/\\\\]target\\'" "[/\\\\]tmp\\'"))
    (add-to-list 'lsp-file-watch-ignored-directories dir)))

(after! vterm
  (setq vterm-kill-buffer-on-exit t
        vterm-max-scrollback 10000
        vterm-tramp-shells '(("ssh" "/bin/zsh")
                             ("podman" "/bin/sh")
                             ("docker" "/bin/sh")
                             ("coder" "/bin/zsh"))))

(after! org
  (add-to-list 'org-babel-load-languages '(mermaid . t)))

(custom-set-faces!
  `(org-date :foreground ,(doom-color 'violet))
  '(org-document-title :height 1.75 :weight bold)
  `(org-level-1 :foreground ,(doom-color 'blue) :height 1.5 :weight bold)
  `(org-level-2 :foreground ,(doom-color 'magenta) :height 1.3 :weight bold)
  `(org-level-3 :foreground ,(doom-color 'violet) :height 1.1 :weight normal)
  `(org-level-4 :foreground ,(doom-color 'cyan)   :height 1.0 :weight normal)
  `(org-level-5 :foreground ,(doom-color 'grey) :weight normal)
  `(org-level-6 :foreground ,(doom-color 'blue) :weight normal))

(use-package! yaml-pro
  :hook (yaml-ts-mode . yaml-pro-ts-mode)
  :config
  (map! :map yaml-pro-ts-mode-map
        :n "gk" #'yaml-pro-ts-prev-subtree
        :n "gj" #'yaml-pro-ts-next-subtree
        :n "gK" #'yaml-pro-ts-up-level
        :n "M-k" #'yaml-pro-ts-move-subtree-up
        :n "M-j" #'yaml-pro-ts-move-subtree-down))

(use-package! majutsu
  :commands (majutsu majutsu-log)
  :init (map! :leader :desc "Majutsu (jj)" "g j" #'majutsu)
  :config
  (after! forge
    (require 'majutsu-forge)
    (majutsu-forge-mode 1)))

(use-package! vc-jj :after vc)

(after! lsp-pyright
  (setq lsp-pyright-langserver-command "basedpyright"))

(setq display-time-default-load-average nil)

(defface +diff-hl-line-insert '((t :extend t)) "Background of added lines.")
(defface +diff-hl-line-change '((t :extend t)) "Background of changed lines.")
(custom-set-faces!
  `(+diff-hl-line-insert :background ,(doom-blend 'green 'bg 0.1))
  `(+diff-hl-line-change :background ,(doom-blend 'blue 'bg 0.1)))

(defun +diff-hl-fringe-and-line (ovl type shape)
  "Fringe mark plus a faint background over the whole changed line."
  (diff-hl-highlight-on-fringe ovl type shape)
  (unless (eq type 'delete)
    (move-overlay ovl (overlay-start ovl)
                  (save-excursion (goto-char (overlay-start ovl)) (line-beginning-position 2)))
    (overlay-put ovl 'face (if (eq type 'insert) '+diff-hl-line-insert '+diff-hl-line-change))))

(after! diff-hl
  (setq diff-hl-highlight-function #'+diff-hl-fringe-and-line))

(defun +gladiators-key ()
  (string-trim (shell-command-to-string
                "security find-generic-password -a gptel -s ai.gladiators.dev -w")))

(after! gptel
  (setq gptel-model 'code-local
        gptel-backend (gptel-make-openai "gladiators"
                        :host "ai.gladiators.dev"
                        :stream t
                        :key #'+gladiators-key
                        :models '(code-local fast fable))))

(defun +lookup/file-other-window ()
  "Like `gf', but open in the next existing window (splits if there is only one)."
  (interactive)
  (let ((buf (current-buffer)) (pos (point)))
    (select-window (or (next-window) (split-window-right)))
    (switch-to-buffer buf)
    (goto-char pos)
    (+lookup/file)))

(map! :n "gO" #'+lookup/file-other-window)
