;;; modus-themes-exporter.el --- Export a Modus themes to another application -*- lexical-binding:t -*-

;; Copyright (C) 2026  Protesilaos Stavrou

;; Author: Protesilaos Stavrou <info@protesilaos.com>
;; Maintainer: Protesilaos Stavrou <info@protesilaos.com>
;; URL: https://github.com/protesilaos/modus-themes-exporter
;; Version: 0.0.0
;; Package-Requires: ((emacs "28.1") (modus-themes "5.2.0"))
;; Keywords: faces, theme, accessibility

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Export a Modus themes to another application.  The idea is to write
;; a color scheme for a terminal emulator or some other program.
;;
;; The point of entry is the command `modus-themes-exporter-export'.
;; Read its documentation to learn more about how it works.
;;
;; Supported target applications are listed in the variable
;; `modus-themes-exporter-supported-applications'.  More templates can
;; be added, based on demand---so do contact me!

;;; Code:

(require 'modus-themes)

(defvar modus-themes-exporter-supported-applications
  '(urxvt xterm)
  "List of symbols representing applications to export a Modus theme to.")

(defvar modus-themes-exporter-application-prompt-history nil
  "Minibuffer history for the `modus-themes-exporter-application-prompt'.")

(defun modus-themes-exporter-application-prompt (&optional text)
  "Prompt for an application among `modus-themes-exporter-supported-applications'.
With optional TEXT use it instead of a generic prompt."
  (let ((default (car modus-themes-exporter-application-prompt-history)))
    (intern
     (completing-read
      (format-prompt (or text "Select target APPLICATION") default)
      modus-themes-exporter-supported-applications
      nil t nil 'modus-themes-exporter-application-prompt-history default))))

(defun modus-themes-exporter--get-color (color palette)
  "Get the COLOR value from the PALETTE.
COLOR is a symbol while PALETTE is an alist of the form returned by the
function `modus-themes-get-theme-palette'."
  (modus-themes-retrieve-palette-value color palette))

(defmacro modus-themes-exporter-define-xresources (application)
  "Define a function that is of the XResources type for APPLICATION."
  `(defun ,(intern (format "modus-themes-exporter-get-%s" application))  (palette)
     ,(format "Return `%s' theme given PALETTE." application)
     (unless palette
       (error "The palette cannot be nil"))
     (let* ((background (modus-themes-exporter--get-color 'bg-main palette))
            (background-dim (modus-themes-exporter--get-color 'bg-dim palette))
            (foreground (modus-themes-exporter--get-color 'fg-main palette))
            (foreground-dim (modus-themes-exporter--get-color 'fg-dim palette))
            (bg-dark-p (modus-themes-color-dark-p background))
            (black (if bg-dark-p
                       background
                     foreground))
            (black-bright (if bg-dark-p
                              background-dim
                            foreground-dim))
            (white (if bg-dark-p
                       foreground-dim
                     background-dim))
            (white-bright (if bg-dark-p
                              foreground
                            background))
            (red (modus-themes-exporter--get-color 'red palette))
            (green (modus-themes-exporter--get-color 'green palette))
            (yellow (modus-themes-exporter--get-color 'yellow palette))
            (blue (modus-themes-exporter--get-color 'blue palette))
            (magenta (modus-themes-exporter--get-color 'magenta palette))
            (cyan (modus-themes-exporter--get-color 'cyan palette))
            (red-bright (modus-themes-exporter--get-color 'red-warmer palette))
            (green-bright (modus-themes-exporter--get-color 'green-warmer palette))
            (yellow-bright (modus-themes-exporter--get-color 'yellow-cooler palette))
            (blue-bright (modus-themes-exporter--get-color 'blue-warmer palette))
            (magenta-bright (modus-themes-exporter--get-color 'magenta-cooler palette))
            (cyan-bright (modus-themes-exporter--get-color 'cyan-cooler palette)))
       (concat
        ,(format "%s*background: " application) background "\n"
        ,(format "%s*foreground: " application) foreground "\n"
        ,(format "%s*color0: " application) black "\n"
        ,(format "%s*color1: " application) red "\n"
        ,(format "%s*color2: " application) green "\n"
        ,(format "%s*color3: " application) yellow "\n"
        ,(format "%s*color4: " application) blue "\n"
        ,(format "%s*color5: " application) magenta "\n"
        ,(format "%s*color6: " application) cyan "\n"
        ,(format "%s*color7: " application) white "\n"
        ,(format "%s*color8: " application) black-bright "\n"
        ,(format "%s*color9: " application) red-bright "\n"
        ,(format "%s*color10: " application) green-bright "\n"
        ,(format "%s*color11: " application) yellow-bright "\n"
        ,(format "%s*color12: " application) blue-bright "\n"
        ,(format "%s*color13: " application) magenta-bright "\n"
        ,(format "%s*color14: " application) cyan-bright "\n"
        ,(format "%s*color15: " application) white-bright "\n"))))

(modus-themes-exporter-define-xresources xterm)
(modus-themes-exporter-define-xresources urxvt)

(defun modus-themes-exporter--get-theme (application palette)
  "Return the theme of APPLICATION, using the given PALETTE."
  (unless palette
    (error "The palette cannot be nil"))
  (pcase application
    ('xterm (modus-themes-exporter-get-xterm palette))
    ('urxvt (modus-themes-exporter-get-urxvt palette))
    (_ (error "The application `%s' is not known" application))))

(defvar modus-themes-exporter-output-prompt-history nil
  "Minibuffer history for the `modus-themes-exporter-output-prompt'.")

(defconst modus-themes-exporter-output-types '(file buffer kill-ring)
  "Types of output supported by `modus-themes-exporter-export'.")

(defun modus-themes-exporter-get-completion-table (candidates &rest metadata)
  "Return completion table with CANDIDATES and METADATA.
CANDIDATES is a list of strings.  METADATA is described in
`completion-metadata'."
  (lambda (string pred action)
    (if (eq action 'metadata)
        (cons 'metadata metadata)
      (complete-with-action action candidates string pred))))

(defun modus-themes-exporter-output-annotate (string)
  "Annotate STRING."
  (format " %s%s"
          (propertize " " 'display '(space :align-to 20))
          (pcase string
            ("" "")
            ("buffer" "Write to a buffer and display it")
            ("file" "Write to a file and display its buffer")
            ("kill-ring" "Save to the `kill-ring'"))))
      
(defvar modus-themes-exporter-output-types-metadata
  '((category . nil)
    (annotation-function . modus-themes-exporter-output-annotate))
  "Completion metadata for `modus-themes-exporter-output-prompt'.")

(defun modus-themes-exporter-output-prompt ()
  "Prompt for an output per the `modus-themes-exporter-export'."
  (let ((default (car modus-themes-exporter-output-prompt-history)))
    (intern
     (completing-read
      (format-prompt "Select output method" default)
      (apply
       #'modus-themes-exporter-get-completion-table
       modus-themes-exporter-output-types
       modus-themes-exporter-output-types-metadata)
      nil t nil 'modus-themes-exporter-output-prompt-history default))))

 (defun modus-themes-exporter--output-buffer (string &optional buffer)
  "Insert STRING into BUFFER and display it.
If BUFFER is nil, use the *modus-themes-exporter* buffer."
  (let ((buffer (or buffer (get-buffer-create "*modus-themes-exporter*"))))
    (with-current-buffer buffer
      (erase-buffer)
      (insert string))
    (prog1
        buffer
      ;; TODO 2026-04-13: Maybe we can add a user option for an action
      ;; alist.  But for now this is not needed.
      (display-buffer buffer))))

(defun modus-themes-exporter--output-kill-ring (string)
  "Add the STRING to the `kill-ring'."
  (kill-new string)
  (message "Saved theme to the `kill-ring'"))

(defun modus-themes-exporter--output-file (file string)
  "Write to FILE the STRING.
Display the corresponding buffer and return the buffer."
  (catch 'exit-early
    (when (file-exists-p file)
      (unless (y-or-n-p "File exists; OVERWRITE it? ")
        (throw 'exit-early
               (prog1
                   nil
                 (message "Will not write to file `%s'" file)))))
    (let ((buffer (find-file-noselect file)))
      (modus-themes-exporter--output-buffer string buffer)
      (with-current-buffer buffer
        (save-buffer))
      buffer)))
  
(defun modus-themes-exporter--output-result (output string)
  "Use OUTPUT to present the RESULT.
OUTPUT is a member of `modus-themes-exporter-output-types'.
STRING is the theme of a supported target application."
  (pcase output
    ('buffer (modus-themes-exporter--output-buffer string))
    ('kill-ring (modus-themes-exporter--output-kill-ring string))
    ((pred stringp) (modus-themes-exporter--output-file output string))
    ('file (error "The `file' output should be represented as a file path"))
    (_ (error "The output `%s' is unknown" output))))
  
;;;###autoload
(defun modus-themes-exporter-export (theme application &optional output)
  "Export Modus THEME to the given APPLICATION.
When called interactively, prompt for THEME and then prompt for APPLICATION.

When called from Lisp, THEME is a symbol of a Modus theme that is among
those returned by the function `modus-themes-get-themes'.  APPLICATION
is a symbol among the `modus-themes-exporter-supported-applications'.

Optional OUTPUT is how to return the theme for the APPLICATION.  When
called interactively, OUTPUT is the prefix argument, in which case
prompt for a method among the following:

- `file': select a file to write to, creating it if necessary;
- `buffer': write the theme in a new *modus-themes-exporter* buffer;
- `kill-ring': save the theme to the `kill-ring'.

If OUTPUT is not specified, default to `buffer' as noted above."
  (interactive
   (list
    (modus-themes-select-prompt "Select THEME to export")
    (modus-themes-exporter-application-prompt)
    (when current-prefix-arg
      (let ((output (modus-themes-exporter-output-prompt)))
        (if (eq output 'file)
            (read-file-name "Select FILE to write to: ")
          output)))))
  (if-let* ((palette (modus-themes-get-theme-palette theme))
            (result (modus-themes-exporter--get-theme application palette)))
      (if output
          (modus-themes-exporter--output-result output result)
        (modus-themes-exporter--output-result 'buffer result))
    (user-error "The theme `%s' does not have a palette" theme)))

(provide 'modus-themes-exporter)
;;; modus-themes-exporter.el ends here
