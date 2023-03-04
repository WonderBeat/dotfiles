;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "wonderbeat"
      user-mail-address "wombat@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "MesloLGL Nerd Font" :size 13 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "MesloLGL Nerd Font" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(pcre-mode +1)

(setq confirm-kill-emacs nil)

;; (setq tree-sitter-load-path `(
;;                              ,"~/.bin"))


;; (add-to-list 'tree-sitter-major-mode-language-alist '(csharp-tree-sitter-mode . c-sharp))
;; (add-to-list 'tree-sitter-major-mode-language-alist '(zig-mode . (tree-sitter-require 'zig)))
;; (tree-sitter-require 'zig)


;; (use-package! tree-sitter
;;   :config
;;   (require 'tree-sitter-langs)
;;   (global-tree-sitter-mode)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;   (pushnew! tree-sitter-major-mode-language-alist '(zig-mode . zig) '(yaml-mode . yaml)))

(add-hook 'yaml-mode-hook #'eldoc-mode)
(add-hook 'yaml-mode-hook #'yaml-pro-ts-mode)

(use-package! zig-mode
  :hook ((zig-mode . lsp-deferred))
  :custom (zig-format-on-save nil)
  :config
  (after! lsp-mode
    (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
    (lsp-register-client
     (make-lsp-client :new-connection (lsp-tramp-connection "zls")
                      :major-modes '(zig-mode)
                      :remote? t
                      :server-id 'zls-remote))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "zls")
      :major-modes '(zig-mode)
      :server-id 'zls))))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

(evil-snipe-mode +1)

(use-package mu4e
  :if (and (memq window-system '(mac ns)) (file-directory-p "~/.mail"))
  :ensure t
  :load-path "/usr/local/share/emacs/site-lisp/mu/mu4e/"
  :init
  (setq! mu4e-maildir (expand-file-name "~/.mail/vk") ; the rest of the mu4e folders are RELATIVE to this one
         mu4e-view-prefer-html t
         mu4e-get-mail-command "mbsync -a"
         mu4e-index-update-in-background t
         shr-color-visible-luminance-min 60
         shr-color-visible-distance-min 5
         shr-use-colors nil
         mu4e-compose-signature-auto-include t
         mu4e-use-fancy-chars t
         mu4e-update-interval nil
         mu4e-view-show-addresses t
         mu4e-view-show-images t
         mu4e-compose-format-flowed t
         mu4e-change-filenames-when-moving t ;; http://pragmaticemacs.com/emacs/fixing-duplicate-uid-errors-when-using-mbsync-and-mu4e/
         mu4e-maildir-shortcuts
         '( ("/vk/Inbox" . ?i)
            ("/vk/monitoring/Hashek Log" . ?l)
            ("/vk/huntflow" . ?h)
            ("/vk/Deleted Items" . ?t)
            ("/vk/Sent Items" . ?s))
         ;; Message Formatting and sending
         message-send-mail-function 'smtpmail-send-it
         ;; message-signature-file "~/Documents/dotfiles/Emacs/.doom.d/.mailsignature"
         message-citation-line-format "On %a %d %b %Y at %R, %f wrote:\n"
         message-citation-line-function 'message-insert-formatted-citation-line
         message-kill-buffer-on-exit t
         ;; Org mu4e
         org-mu4e-convert-to-html t
         ))

(add-hook 'mu4e-update-pre-hook 'etc/imapfilter)
(defun etc/imapfilter ()
  (message "Running imapfilter...")
  (with-current-buffer (get-buffer-create " *imapfilter*")
    (goto-char (point-max))
    (insert "---\n")
    (call-process "/usr/local/bin/imapfilter" nil (current-buffer) nil "-c"
                  (format  "/Users/%s/.imapfilter.lua" user-login-name) "-v"))
  (message "Running imapfilter...done"))

(set-email-account! "denis.golovachev@vk.team"
                    '((user-mail-address      . "denis.golovachev@vk.team")
                      (user-full-name         . "Denis Golovachev")
                      (smtpmail-smtp-server   . "es.vkcorporate.com")
                      (smtpmail-smtp-service  . 587)
                      (smtpmail-stream-type   . starttls)
                      (smtpmail-debug-info    . t)
                      (mu4e-drafts-folder     . "/vk/Drafts")
                      (mu4e-refile-folder     . "/vk/Archive")
                      (mu4e-sent-folder       . "/vk/Sent Items")
                      (mu4e-trash-folder      . "/vk/Deleted Items")
                      (mu4e-update-interval   . nil)
                      ;(mu4e-sent-messages-behavior . 'delete)
                      )
                    nil)

(setenv "TZ" "Europe/Moscow")
(setq datetime-timezone 'Europe/Moscow)


(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      ;; scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      scroll-margin 2)                            ; It's nice to maintain a little margin

(display-time-mode 1)                             ; Enable time in the mode-line

;; (unless (string-match-p "^Power N/A" (battery))   ; On laptops...
;;   (display-battery-mode 1))                       ; it's nice to know how much power you have

(global-subword-mode 1)

;(with-eval-after-load 'geiser
;  (setq-default geiser-chicken-binary "/usr/local/Cellar/chicken/5.3.0/bin/csi")
;  (setq-default geiser-active-implementations
;                '(chicken racket guile chez mit chibi)))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]build\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]gradle\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]target\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]tmp\\'"))


(use-package languagetool
  :ensure t
  :defer t
  :commands (languagetool-check
             languagetool-clear-suggestions
             languagetool-correct-at-point
             languagetool-correct-buffer
             languagetool-set-language
             languagetool-server-mode
             languagetool-server-start
             languagetool-server-stop)
  :config
  (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8")
        languagetool-console-command "~/.bin/langtool/languagetool-commandline.jar"
        languagetool-server-command "~/.bin/langtool/languagetool-server.jar"))

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview)
  :config
  (setq kubernetes-poll-frequency 17000
        kubernetes-redraw-frequency 17000))

(use-package kubernetes-evil
  :ensure t
  :after kubernetes)

(use-package kubel-evil)
(use-package earthfile-mode
  :ensure t)

(use-package! lsp
  :init
  (setq lsp-pyls-plugins-pylint-enabled t
        lsp-pyls-plugins-autopep8-enabled nil
        lsp-pyls-plugins-pyflakes-enabled t
        lsp-pyls-plugins-pycodestyle-enabled nil
        lsp-pyls-plugins-jedi-completion-enabled t
        lsp-pyls-plugins-jedi-completion-include-params t
        lsp-pyls-plugins-yapf-enabled t)
  )

(setq code-review-auth-login-marker 'forge)

(use-package vterm
  :commands vterm-mode
  :config
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-max-scrollback 10000))

(use-package kubel
  :ensure t
  :config
  (setq kubel-log-tail-n 10000))

;; (use-package ispell
;;   :config
;;   (setq ispell-dictoinary "en")
;;   (setq ispell-personal-dictionary "~/.config/dictionaries"))

;; (use-package spell-fu
;;   :defer t
;;   :config
;;   (setq spell-fu-directory "~/Library/Spelling/")
;;     (add-hook 'spell-fu-mode-hook
;;             (lambda ()
;;                 (spell-fu-dictionary-add (spell-fu-g"en_US"))
;;                 (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "russian"))))
;; )

(org-babel-do-load-languages
    'org-babel-load-languages
    '((mermaid . t)))


(custom-set-faces!
  `(org-date :foreground ,(doom-color 'violet))
  '(org-document-title :height 1.75 :weight bold)
  ;; `(org-level-1 :foreground ,(doom-color 'blue) :height 1.4 :weight bold :background ,(doom-color 'grey))
  `(org-level-1 :foreground ,(doom-color 'blue) :height 1.5 :weight bold)
  `(org-level-2 :foreground ,(doom-color 'magenta) :height 1.3 :weight bold)
  `(org-level-3 :foreground ,(doom-color 'violet) :height 1.1 :weight normal)
  `(org-level-4 :foreground ,(doom-color 'cyan)   :height 1.0 :weight normal)
  `(org-level-5 :foreground ,(doom-color 'grey) :weight normal)
  `(org-level-6 :foreground ,(doom-color 'blue) :weight normal))

(use-package! yaml-pro
  :after yaml-mode
  :hook (yaml-mode . yaml-pro-mode)
  :config
  (map! :map yaml-pro-mode-map
       [remap imenu] #'yaml-pro-jump
        :n "zc" #'yaml-pro-fold-at-point
        :n "zo" #'yaml-pro-unfold-at-point
        :n "gk" #'yaml-pro-prev-subtree
        :n "gj" #'yaml-pro-next-subtree
        :n "gK" #'yaml-pro-up-level
        :n "M-k" #'yaml-pro-move-subtree-up
        :n "M-j" #'yaml-pro-move-subtree-down))
