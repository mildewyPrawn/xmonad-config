;; Modulo para la carga de paquetes de terceros
(require 'package)

;; Modulo para usar acentos
(require 'iso-transl)

;; Lista de repositorios de donde otener paquetes para emacs.
(setq package-archives '(("marmalade" . "http://marmalade-repo.org/packages/")
			  ("tromey" . "http://tromey.com/elpa/")
			  ("elpa" . "http://elpa.gnu.org/packages/")
			  ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Permite cargar los repositorios definidos anteriormente
(package-initialize)

;; Borrar la pantalla de inicio de emacs.
(setq inhibit-startup-screen t)

(when (not package-archive-contents)
  (package-refresh-contents))

;; lenguajes para org-mode
(org-babel-do-load-languages
  'org-babel-load-languages
    '((python . t)
      (matlab . t)))

;; (setq org-todo-keywords'((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))

;; Creo que aquí defino todos los paquetes que tengo descargados.
(defvar my-packages
  '(py-autopep8
    auto-complete
    autopair
    flycheck
    helm
    projectile
    dracula-theme
    nyan-mode
    haskell-mode
    fill-column-indicator
    ace-mc
    rainbow-delimiters))

;; Creo que con esto descargo todos los paquetes que tengo instalados si es que
;; no están instalados
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; (require 'telephone-line)
;; (telephone-line-mode 1)

;; (require 'all-the-icons)
;; (insert (all-the-icons-icon-for-file "*.hs"))

;; (global-undo-tree-mode nil) ;; Conflicts with keybindings

;; Borrar barras superiores.
;; Cambiar a 1 si se quieren habilitar.
(menu-bar-mode 0) ;; Barra con File Edit Buffers, ...
(tool-bar-mode 0) ;; Barra para para copiar, pegar, salvar, ...

;; Cambiar tipografía.
(set-default-font "DejaVu Sans Mono 11") ;; Puedes buscar en internet otras.

;; IDO mode (Autocompleta).
;; Cambiar a 0 si se quiere deshabilitar.
(ido-mode 1)

;; SMEX mode (Autocompleta M-x)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Número de línea
;; Cambiar a 0 para desactivar
(global-linum-mode 1)

;; Desactivar mensajes
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

(setq column-number-mode t) ;; Pone el número de linea y columna en el modeline.
;; Cambiamos el título del Frame. El de hasta arriba xd
(setq-default frame-title-format "%b\t(%f)") 
(global-hl-line-mode 1) ;; Resalta la linea actual.
(show-paren-mode 1) ;; Resalta el apareamiento de parentesis, llaves, etc.
(setq-default indent-tabs-mode nil) ;; No tabuladores duros
(nyan-mode t) ;; nyan-cat es una barra que muestra el avance del buffer.


(require 'autopair)
;;(autopair-global-mode 0) ;; autocompleta "", (), [],{}, 
(electric-pair-mode 1);; autocompleta: (), [], {}, "", ''
;; make electric-pair-mode work on more brackets.
(setq electric-pair-pairs
      '(
        (?\" . ?\")
        (?\{ . ?\})
        (?\' . ?\')))
(require 'rainbow-delimiters)

(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode t)))
(global-fci-mode t) ;; activa fci-mode por siempre
(setq fci-rule-color "red") ;; color de la columna límite
(setq fci-rule-column 81) ;; establece el límite en 80

;; CapsLock para agregar un mark set
;; Falta hacerlo :(

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;                   defalias                  ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Alias for scroll-up (Now scroll-ahead)
(defalias 'scroll-ahead 'scroll-up)

;; Alinas for scroll-down (Now scroll-behind)
(defalias 'scroll-behind 'scroll-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                   defun                  ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define other-window-backward command
(defun other-window-backward (&optional n)
  "Select Nth previous window."
  (interactive "P")
  (other-window (- (prefix-numeric-value n))))

;; Define function that comment or uncomment the actual line
(defun toggle-comment-on-line ()
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))

;; Define function for scroll lines ahead.
;; Can take an argument n with the number of lines to scroll.
(defun scroll-n-lines-ahead (&optional n)
  "Scroll ahead N lines"
  (interactive "P")
  (scroll-ahead (prefix-numeric-value n)))

;; Define function for scroll lines behind.
;; Can take an argument n with the number of lines to scroll.
(defun scroll-n-lines-behind (&optional n)
  "Scroll behind N lines"
  (interactive "P")
  (scroll-behind (prefix-numeric-value n)))

;; Function that tests whether current buffer's file is a symlink. If it is,
;; the buffer is made read-only and the message "File is a symlink" is
;; displayed.
(defun read-only-if-symlink ()
  (if (file-symlink-p buffer-file-name)
      (progn
	(setq buffer-read-only t)
	(message "File is a symlink"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                 defadvice                 ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Advice if open a symlink.
(defadvice switch-to-buffer (before existing-buffer
				    activate compile)
  "When interactive, switch to existing buffers only,
  unless given prefix argument."
  (interactive
   (list (read-buffer "Switch to buffer:"
		      (other-buffer)
		      (null current-prefix-arg)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;               global-set-key              ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Multiple vertical cursors (one obove another).
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;; Command for comment or uncomment the actual line.
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; Comentar una sección :: Arreglar a poder descomentar porque vuelve a comentar.
(global-set-key (kbd "C-x ,") 'comment-dwim)

;; Redefine help-command (before "C-h").
(global-set-key (kbd "C-?") 'help-command)

;; Redefine delete-backward-char (delete with C-h).
(global-set-key (kbd "C-h") 'delete-backward-char)

;; Define keybinding for 'other-window-backward'.
(global-set-key (kbd "C-x C-o") 'other-window-backward)

;; Redefine next-buffer command (before C-x 'right-arrow').
(global-set-key (kbd "C-x C-¿") 'next-buffer)

;; Redefine previous-buffer command (before "C-x 'left-arrow').
(global-set-key (kbd "C-x C-'") 'previous-buffer)

;; Define scroll lines. This scroll the text down.
(global-set-key (kbd "C-q") 'scroll-n-lines-behind)

;; Define scroll lines. This scroll the text up.
(global-set-key (kbd "C-z") 'scroll-n-lines-ahead)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                   hooks                  ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add read-only-if-symlink to find-file-hook
(add-hook 'find-file-hooks 'read-only-if-symlink)

;; le pone colores a los paréntesis anidados.
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (dracula)))
 '(custom-safe-themes
   (quote
    ("dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" "55c2069e99ea18e4751bd5331b245a2752a808e91e09ccec16eb25dadbe06354" "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" default)))
 '(haskell-font-lock-symbols t)
 '(nyan-animate-nyancat t)
 '(nyan-wavy-trail t)
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(package-selected-packages
   (quote
    (linum-relative ein master-mode sml-mode lsp-haskell lsp-ui lsp-mode liquid-types flycheck-color-mode-line button-lock pos-tip haskell-mode flycheck-liquidhs 2048-game rainbow-delimiters ace-mc fill-column-indicator nyan-mode dracula-theme py-autopep8 projectile helm flycheck autopair auto-complete)))
 '(send-mail-function (quote mailclient-send-it)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
