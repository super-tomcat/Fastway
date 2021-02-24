;;; -*- lexical-binding: t; -*-
;; 
;; FASTWAY for Emacs
;; Quickly move point to words, numbers and delimiters on the current line.
;;
;; Copyright (C) 2020 Neil Higgins
;; Created: 28-Oct-2020
;; Author: Neil Higgins
;;
;; Reason for writing this.... we have Avy and Ace-jump for quickly moving to most
;; places on the screen, which work very well, however i found them a bit overwhelming,
;; lots of chars popping up everywhere showing where to jump to, plus out of habit i
;; usually found myself already on the line i wanted to edit before thinking about
;; Avy which kind of defeated the object.
;; Having found myself already on the line i'd then do something like lots
;; of right cursors or even Ctrl-right and Ctr-left cursors etc to get where i wanted,
;; which, depending on how long the line was could involve quite a few keypresses, hence
;; Fastway was born.
;; 
;; =====================================================================
;; 
(require 'cl-lib)
;;
;; 
(defvar fastway-matches-list-text nil
  "The text of Fastway matches.")
;; 
(defvar fastway-matches-list-start nil
  "The buffer start positions of Fastway matches.")
;;
(defvar fastway-matches-list-end nil
  "The buffer end positions of Fastway matches.")

(defun fastway-find-all-matches-main (regex)
  ""
  (save-excursion
    (setq fastway-matches-list-text nil)
    (setq fastway-matches-list-start nil)
    (setq fastway-matches-list-end nil)
    (goto-char (line-beginning-position))
    (while (re-search-forward regex (line-end-position) t)

      (push (match-string-no-properties 0) fastway-matches-list-text)

      (push (- (point) (length (match-string-no-properties 0))) fastway-matches-list-start)
      ;; 
      (push (point) fastway-matches-list-end)))
  (setq fastway-matches-list-text (nreverse fastway-matches-list-text))
  (setq fastway-matches-list-start (nreverse fastway-matches-list-start))
  (setq fastway-matches-list-end (nreverse fastway-matches-list-end)))
;;
;;
(defgroup fastway nil
  "Fast way to move point to words and delimiters on the current line."
  :prefix "fastway"
  :link '(url-link "https://github.com/super-tomcat/Fastway"))
;;
;; 
(defface fastway-matches-overlay-face-1
  '((t :inherit highlight))
  "*Face number 1 which is used to highlight the Fastway positions you will jump to.
See `fastway-overlay-default-choice' to set this to the default when you start a new
session"
  :group 'fastway)
;;
;;
(defface fastway-matches-overlay-face-2
  '((t :inherit underline))
  "*Face number 2 which is used to highlight the Fastway positions you will jump to.
See `fastway-overlay-default-choice' to set this to the default when you start a new
session"
  :group 'fastway)
;;
;; 
(defface fastway-matches-overlay-face-3
  '((t (:inherit default :foreground "yellow" :background "blue")))
  "*Face number 3 which is used to highlight the Fastway positions you will jump to.
See `fastway-overlay-default-choice' to set this to the default when you start a new
session"
  :group 'fastway)
;;
;;
(defcustom fastway-overlay-default-choice 1
  "Use this option to set Fastways default overlay. In other words how the matches
are highlighted when Fastway is first switched on. You can only choose one
face out of two, or you can elect to have no overlay which means no highlighting."
  :type '(choice (const :tag "Fastway Matches Overlay 1" 1)
                (const :tag "Fastway Matches Overlay 2" 2)
                (const :tag "No Overlay" 3)) 
  :group 'fastway)
;; 
(defconst fastway-matches-overlay-name 'fastway-matches-overlay-name)
;; 
(defcustom fastway-toggle-key-default "C-,"
  "Key used to toggle Fastway mode on/off."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-key-regex-switch "C-."
  "Key used to switch between different regex in `fastway-line-match-regex'.
Each regex determines what positions will be highlighted and jumped to.
This key will only apply when Fastway is switched on."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-key-overlay-switch "M-C-,"
  "Key used to switch between overlays in `fastway-matches-overlay-face-1',
 `fastway-matches-overlay-face-2' and `fastway-matches-overlay-face-3'or
to turn the overlay off. This key will only apply when Fastway is switched on."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-key-movement-mode-switch "M-C-'"
  "Key used to switch between Fastway movement modes, only works when Fastway
is already on. 
The modeline will update to show which mode you are in."
  :type 'string
  :group 'fastway)
;; 
(defcustom fastway-key-move-left "<left>"
  "If fastway is in Cursor mode then this is the key used to move to the next position on the left.
This key will only apply when Fastway is switched on."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-key-move-right "<right>"
  "If fastway is in Cursor mode then this is the key used to move to the next position on the right.
This key will only apply when Fastway is switched on."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-key-show-keys "C-C f k"
  "Display fastway keys in seperate window"
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-line-match-regex
  '(
    ("Words and Numbers" "[A-Za-z0-9]+")    

    ("Delimeters and Numbers" "[]\\(\\){}'~<>!=*+-?@_%|&^/\\\\\":;#$,`.[]\\|\\B-\\B\\|[0-9]+")
    
    ("Words joined with - and Numbers" "[-A-Za-z0-9]+")
    )
"These are the regular expressions that Fastway uses to find matches.
Each element should look like (\"Name\" \"Regex\"), the Name string will be shown
as a message when you switch between them while Fastway is on, the Regex string
will only apply to the current line that point is on, even if a region is active.
"
:type '(alist :key-type (string :tag "Name") :value-type (group (string :tag "Regex")))
:group 'fastway
)
;;
(defcustom fastway-char-mode-case-sensitive nil
  "If this is On (t) then in Character mode, keys are case sensitive, which means
for example you will need to press W (shift-w) to move to W characters, etc. If 
this is Off (nil)(default) then pressing either w or W (shift-w) will move to
both w and W."
  :type 'boolean
  :group 'fastway)
;;
(defcustom fastway-default-regex-index 1
  "This is the index to the regex you want to start each session of Fastway with.
This must be in range of the total number of regex you have in `fastway-line-match-regex'.
Also see `fastway-start-with-last-used-regex' to overide this each time you switch Fastway on
during the current session."
  :type 'integer
  :group 'fastway)
;;
(defcustom fastway-start-with-last-used-regex t
  "If this is On (non nil) (default) then whenever you switch Fastway on during the
current session it will start with the last used regex. If this is Off (nil) then
whenever you switch Fastway on it will always start with the Regex pointed to
by `fastway-default-regex-index'."
  :type 'boolean
  :group 'fastway)
;; 
(defcustom fastway-overlay-priority 201
  "The priority of the overlay used to indicate matches."
  :type 'integer
  :group 'fastway)
;;
(defcustom fastway-display-message t
  "If this is On (non nil) (default) then whenever you switch Fastway on or off
a message will also be displayed."
  :type 'boolean
  :group 'fastway)
;;
(defcustom fastway-main-modeline-string " Fastway"
  "The main string displayed in the modeline when Fastway is on."
  :type 'string
  :group 'fastway)
;; 
(defcustom fastway-cursor-movement-modeline-string "[curs]"
  "Modeline string appended to `fastway-main-modeline-string' when Fastway is in cursor movement mode."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-character-movement-modeline-string "[char]"
  "Modeline string appended to `fastway-main-modeline-string' when Fastway is in character movement mode."
  :type 'string
  :group 'fastway)
;;
(defcustom fastway-default-movement-mode 1
  "Use this option to set Fastways default movement. Cursor Movement lets you use
2 keys to move left and right to each match, the advantage with this mode is that
you can still edit the line while its on, the disadvantage compared to Character
Movement is that it may take more key presses to get to where you want. 
Character Movement lets you press keys corresponding to the match you want to move
to, in some cases it can take less keys to get to where you want than with Cursor
Movement, the disadvantage is that you cannot edit the line while this mode is on.
You can also switch between either mode while Fastway is on."
  :type '(choice (const :tag "Cursor Movement" 1)
                (const :tag "Character Movement" 2))
  :group 'fastway)
;; 
;; 
;; ====================================================================================
;; 
(defvar fastway-matches-overlays nil
  "Contains a list of overlays used to
indicate the position of each match to jump to.  In addition, the
matches overlay is used to provide a different face
configurable via `fastway-matches-overlay-face-1', `fastway-matches-overlay-face-2'
and `fastway-matches-overlay-face-3'.")
;; 
;; 
(global-set-key (kbd fastway-toggle-key-default) 'fastway-toggle)
;;
(defvar fastway-mode-map (make-sparse-keymap)
  "Keymap for `fastway-mode'.")
;;
(defvar fastway-next-position nil)
(defvar fastway-current-regex-index fastway-default-regex-index)
(defvar fastway-current-overlay fastway-overlay-default-choice)
(defvar fastway-current-movement-mode fastway-default-movement-mode)
(defvar fastway-matches-list-first-char nil)
(defvar fastway-matches-string-first-char nil)
;;
;; GLOBAL KEYS while in Fastway Mode - most of these can be customised
;; Note that when Fastway is in Cursor mode the default keys to move
;; to each match are the cursor right and left keys, if the user
;; needs to move a character at a time on the same line they can
;; still do this using C-f and C-b instead of the Cursor keys
;; ===============================================================
(define-key fastway-mode-map (kbd fastway-toggle-key-default) 'fastway-toggle)
(define-key fastway-mode-map (kbd fastway-key-regex-switch) 'fastway-use-next-regex)
(define-key fastway-mode-map (kbd fastway-key-overlay-switch) #'fastway-overlay-switcher)
(define-key fastway-mode-map (kbd fastway-key-movement-mode-switch) #'fastway-movement-mode-switcher)
;;
(define-key fastway-mode-map (kbd fastway-key-move-right) #'fastway-cursor-move-right)
(define-key fastway-mode-map (kbd fastway-key-move-left) #'fastway-cursor-move-left)
(define-key fastway-mode-map (kbd fastway-key-show-keys) #'fastway-show-keymap)
;;
;; =========================================================== 
(defvar fastway-aborting-hook nil
  "Functions to call before fastway-abort.  Normally it should be mode exit function.")
;; 
(defvar fastway-mode nil) ;; This minor modes name
;;
(defvar fastway-mode-hook nil
  "Function(s) to call after starting up fastway.")
;; 
(defvar fastway-mode-end-hook nil
  "Function(s) to call after terminating fastway.")
;;
(defvar fastway-mode-line-string nil)
;;

(if (= fastway-current-movement-mode 1)
    (setq fastway-mode-line-string (propertize (concat fastway-main-modeline-string fastway-cursor-movement-modeline-string) 'face 'font-lock-warning-face))
  (setq fastway-mode-line-string (propertize (concat fastway-main-modeline-string fastway-character-movement-modeline-string) 'face 'font-lock-warning-face)))
;;
;; 
;;;###autoload
(define-minor-mode fastway-mode
  "Quickly move point on the current line."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-my-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter (:eval fastway-mode-line-string)
  :keymap fastway-mode-map)
;;
;; 
;;;###autoload
(define-globalized-minor-mode global-my-mode fastway-mode fastway-mode)

;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;; The keymaps in `emulation-mode-map-alists' take precedence over
;; `minor-mode-map-alist'
(add-to-list 'emulation-mode-map-alists `((fastway-mode . ,fastway-mode-map)))
;; 
;;
;; 
(make-variable-buffer-local 'fastway-mode)
(make-variable-buffer-local 'fastway-matches-list-text)
(make-variable-buffer-local 'fastway-matches-list-start)
(make-variable-buffer-local 'fastway-matches-list-end)
(make-variable-buffer-local 'fastway-matches-list-first-char)
(make-variable-buffer-local 'fastway-matches-string-first-char)
(make-variable-buffer-local 'fastway-current-overlay)
(make-variable-buffer-local 'fastway-next-position)
(make-variable-buffer-local 'fastway-current-regex-index)
(make-variable-buffer-local 'fastway-current-movement-mode)
(make-variable-buffer-local 'fastway-mode-line-string)
;;
;; Dont restore Fastway mode when loading a Desktop file
(add-to-list 'desktop-minor-mode-handlers
             '(fastway-mode . ignore))
;; 
(defun fastway-update-after-command-hook ()
  "Updates Fastway after every command"
  (interactive)
  (fastway-get-line-matches))
;;
;; =================================================================
;; 
(defun fastway-move-to-char-hook ()
  "Called when in Character mode to move to a keypress"
  (fastway-move-to-char-main))
;; 
;; =================================================================
;;
(defun fastway-movement-mode-switcher ()
  "Switches Fastway between Cursor and Character Movement Modes"
  (interactive)
  (setq fastway-current-movement-mode (+ 1 fastway-current-movement-mode))
  (if (> fastway-current-movement-mode 2)
      (setq fastway-current-movement-mode 1))
  (if (= fastway-current-movement-mode 1)
      (setq fastway-mode-line-string (propertize (concat fastway-main-modeline-string fastway-cursor-movement-modeline-string) 'face 'font-lock-warning-face))
    (setq fastway-mode-line-string (propertize (concat fastway-main-modeline-string fastway-character-movement-modeline-string) 'face 'font-lock-warning-face))))
;;
;; =================================================================
(defun fastway-overlay-switcher ()
  "Switches Fastway between different Overlays"
  (interactive)
  (setq fastway-current-overlay (+ 1 fastway-current-overlay))
  (if (> fastway-current-overlay 4)
      (setq fastway-current-overlay 1))
  (fastway-get-line-matches))
;; 
;; =================================================================
(defun fastway-show-keymap ()
  ""
  (interactive)
  (with-output-to-temp-buffer (format "*Fastway Keys*")
    (let ((my-column-start 14))
    (princ "Fastway Keys\n\n")
    (princ (format "%s" fastway-toggle-key-default))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-toggle-key-default)) ? ))
    (princ "Toggles Fastway On/Off\n")
    (princ (format "%s" fastway-key-regex-switch))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-key-regex-switch)) ? ))
    (princ "Cycles through regex used for matches\n")
    (princ (format "%s" fastway-key-overlay-switch))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-key-overlay-switch)) ? ))
    (princ "Cycles through overlays used to highlight matches\n")
    (princ (format "%s" fastway-key-movement-mode-switch))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-key-movement-mode-switch)) ? ))
    (princ "Switches between Cursor and Character movement modes\n")
    (princ (format "%s" fastway-key-move-right))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-key-move-right)) ? ))
    (princ "Move point to next match on the right\n")
    (princ (format "%s" fastway-key-move-left))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-key-move-left)) ? ))
    (princ "Move point to next match on the left\n")
    (princ (format "%s" fastway-key-show-keys))
    (beginning-of-line)
    (princ (make-string (- my-column-start (length fastway-key-show-keys)) ? ))
    (princ "Display fastway keys\n")

)))
;; 
;; =================================================================
(defun fastway-get-line-matches ()
  (fastway-find-all-matches-main (nth 1 (nth (- fastway-current-regex-index 1) fastway-line-match-regex)))
  (remove-overlays nil nil fastway-matches-overlay-name t)
  (if fastway-matches-list-start
      (progn
        (if fastway-char-mode-case-sensitive
            (setq fastway-matches-list-first-char (loop for x in fastway-matches-list-text collect (substring x 0 1)))
          (setq fastway-matches-list-first-char (loop for x in fastway-matches-list-text collect (downcase (substring x 0 1)))))
        (setq fastway-matches-string-first-char (mapconcat 'identity fastway-matches-list-first-char ""))
        (if (not (equal 4 fastway-current-overlay))
            (fastway-make-matches-overlays fastway-matches-list-start)))))
;; 
(defun fastway-make-matches-overlays (positions)
  "Create overlays on a list of buffer positions."
  (dolist (element positions)
    (fastway-make-matches-overlay element (+ 1 element))))
;;
;; 
(defun fastway-move-to-char-main ()
  ""
  (interactive)
  ;; if we are not in char mode or there is no matches then ignore rest of code
  (if (= fastway-current-movement-mode 2)
      (if fastway-matches-list-text
          (let* ((user-key-press (key-description (list last-input-event)))
                (user-key-press-copy user-key-press) 
                (first-char-match-positions nil)
                (buffer-char-match-positions nil))
            (if (or (string= user-key-press-copy "\\") (string= user-key-press-copy "["))
                (setq user-key-press-copy (concat "\\" user-key-press-copy)))

            (setq case-fold-search nil)
 
            (if (not fastway-char-mode-case-sensitive)
                (progn
                  (setq user-key-press (downcase user-key-press))
                  (setq user-key-press-copy (downcase user-key-press-copy))
                  (setq case-fold-search t)))
            ;; 
            (when (string-match user-key-press-copy fastway-matches-string-first-char)
               (progn

                 (setq this-command 'ignore)
                 (cl-loop for i from 0 to (length fastway-matches-list-first-char) do (add-to-list 'first-char-match-positions (cl-position user-key-press fastway-matches-list-first-char :test 'equal :start i :end nil) t))

                 (setq first-char-match-positions (remove nil first-char-match-positions))
                 (if (not (some #'null first-char-match-positions))
                     (progn
                       (cl-loop for x in first-char-match-positions do (add-to-list 'buffer-char-match-positions (nth x fastway-matches-list-start) t))
                   (setq fastway-next-position
                         (cl-dolist (x buffer-char-match-positions)
                           (when (> x (point))
                             (cl-return x))))

                   (if fastway-next-position
                       (goto-char fastway-next-position)
                     (goto-char (car buffer-char-match-positions)))))))))))
  
;; =================================================================
(defun fastway-cursor-move-right ()
  "Moves to the next match on the right in Fastway"
  (interactive)
  (if fastway-matches-list-start
      ;;
      (progn

        (setq fastway-next-position
              (cl-dolist (x fastway-matches-list-start)
                (when (> x (point))
                  (cl-return x))))
        (if fastway-next-position
            (goto-char fastway-next-position)
          (goto-char (car fastway-matches-list-start))))))
;;
;; =================================================================
(defun fastway-cursor-move-left ()
  "Moves to the next match on the left in Fastway"
  (interactive)
  (if fastway-matches-list-start
      ;;
      (progn

        (setq fastway-next-position
              (cl-dolist (x (reverse fastway-matches-list-start))
                (when (< x (point))
                  (cl-return x))))
        (if fastway-next-position
            (goto-char fastway-next-position)
          (goto-char (car (last fastway-matches-list-start)))))))
;;
;; =================================================================
;; Get the next regex
(defun fastway-use-next-regex ()
  "Switches regex in Fastway"
  (interactive)
  (setq fastway-current-regex-index (+ 1 fastway-current-regex-index))
  (if (> fastway-current-regex-index (length fastway-line-match-regex))
      (setq fastway-current-regex-index 1))
  (fastway-get-line-matches)
  (message (concat "Fastway will now move to... " (nth 0 (nth (- fastway-current-regex-index 1) fastway-line-match-regex)))))
;;
;;
;; =================================================================
;; 
(defun fastway-toggle ()
  "Start/Stop Fastway mode in the current buffer."
  (interactive)
  (if fastway-mode
      (progn
        (fastway-done)
        (if fastway-display-message
            (message "Fastway mode is off")))
    (progn
      (setq fastway-mode t)
 
      (if (not fastway-start-with-last-used-regex)
          (setq fastway-current-regex-index fastway-default-regex-index))
      (fastway-get-line-matches)

      (add-hook 'post-command-hook #'fastway-update-after-command-hook t t)
      (add-hook 'pre-command-hook #'fastway-move-to-char-hook t t)
      (force-mode-line-update)
      ;; 
      (if fastway-display-message 
          (message (concat "Fastway mode is on - press [ " fastway-key-show-keys " ] for keys"))))))
;;
;; 
(defun fastway-done ()
  "Exit Fastway mode."
  (setq fastway-mode nil)
  (remove-overlays nil nil fastway-matches-overlay-name t)
  (force-mode-line-update)

  (remove-hook 'post-command-hook #'fastway-update-after-command-hook t)
  (remove-hook 'pre-command-hook #'fastway-move-to-char-hook t)
  (remove-hook 'before-revert-hook 'fastway-done t)
  (remove-hook 'kbd-macro-termination-hook 'fastway-done t)
  (remove-hook 'change-major-mode-hook 'fastway-done t)
  (remove-hook 'fastway-aborting-hook 'fastway-done t)
  (run-hooks 'fastway-mode-end-hook))
;;
;;
(defun fastway-make-matches-overlay (begin end)
  "Create an overlay for any matches in Fastway mode.
Add the properties for the overlay: a face used to display a
default value, and modification hooks to update
the overlay if the user starts typing."
  (interactive)
  (let ((matches (make-overlay begin end (current-buffer) nil t)))
    (overlay-put matches fastway-matches-overlay-name t)
    (cond ((equal 1 fastway-current-overlay) (overlay-put matches 'face 'fastway-matches-overlay-face-1))
          ((equal 2 fastway-current-overlay) (overlay-put matches 'face 'fastway-matches-overlay-face-2))
          ((equal 3 fastway-current-overlay) (overlay-put matches 'face 'fastway-matches-overlay-face-3)))
    (overlay-put matches 'priority fastway-overlay-priority)
    (overlay-put matches 'evaporate t)
    (overlay-put matches 'category 'fastway-overlay)
    matches))

;; 
(provide 'fastway-mode)
;;
;;
;; 
;; ==========================================================================================
;; Example Config... put these lines (without ;; at start of them) in your Emacs init file...
;; Restart Emacs, move point to a line containing some text and press C-,
;; ==========================================================================================
;; 
;; (require 'fastway-mode)
;; (global-set-key (kbd fastway-toggle-key-default) 'fastway-toggle)
;;
;;



