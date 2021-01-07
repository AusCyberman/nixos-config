(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(load-theme 'dracula t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (require 'use-package))
(setq lsp-keymap-prefix "s-l")
(require 'lsp-mode)
(use-package lsp-mode
  :hook (haskell-mode . lsp)
  (haskell-iterate-mode . lsp)
  (purescript-mode . lsp)
  (typescript-mode . lsp)
  (javacript-mode . lsp)
  )
(require 'lsp)
(require 'lsp-haskell)
(use-package lsp-ui)
(require 'nix-mode)
(use-package evil
;  :config
;  (evil-mode 1)
  )
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package telephone-line
  :init 
  (defface telephone-line-evil
  '((t (:foreground "#303030" :inherit telephone-line-evil)))
  "Evil mode Foreground"
  :group 'telephone-line-evil)
  (defface telephone-line-evil-insert
    '((t (:background "#fce78d" :inherit telephone-line-evil)))
    "Evil mode insert mode"
    :group 'telephone-line-evil)
  (defface telephone-line-evil-visual
    '((t (:background "#79e5e0" :inherit telephone-line-evil)))
    "Evil mode visual mode"
   :group 'telephone-line-evil)
 (defface telephone-line-evil-replace
   '((t (:background "#f97070" :inherit telephone-line-evil)))
   "Evil mode replace mode"
   :group 'telephone-line-evil)
 (defface telephone-line-evil-normal
   '((t (:background "#f29db4" :inherit telephone-line-evil)))
   "evil mode normal mode";
   :group 'telephone-line-evil)
;  :config
; (telephone-line-mode 1)
 )
;; Hooks so haskell and literate haskell major modes trigger LSP setup

(use-package ligature
  :load-path "~/.emacs.d/ligature.el"
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<*" "<*>" "<+>" "<$>" "***" "<|" "|>" "<|>"
				       "!!" "||" "===" "==>" "<<<" ">>>" "<>" "+++"
				       "<-" "->" "=>" ">>" "<<" ">>=" "=<<" ".."
				       "..." "::" "-<" ">-" "-<<" ">>-" "++" "/=" "=="))

  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(package-initialize)
; (set-frame-parameter (selected-frame) 'alpha '(95 . 95))
; (add-to-list 'default-frame-alist '(alpha . (85 . 85)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(atom-one-dark))
 '(custom-safe-themes
   '("decc9b7a7408b0150d03e34d09ca2c7e4dc5bd424d31892c4ef5ffaf6678920c" "9e39a8334e0e476157bfdb8e42e1cea43fad02c9ec7c0dbd5498cf02b9adeaf1" default))
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(doom-modeline magit atom-one-dark-theme purescript-mode company which-key tide nix-mode flycheck lsp-ui use-package lsp-mode evil telephone-line))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hasklug Nerd Font" :foundry "outline" :slant normal :weight normal :height 102 :width normal)))))

