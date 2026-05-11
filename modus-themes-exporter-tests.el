;;; modus-themes-exporter-test.el --- Unit tests for the Modus themes exporter -*- lexical-binding: t -*-

;; Copyright (C) 2026  Protesilaos

;; Author: Protesilaos <info@protesilaos.com>
;; Maintainer: Protesilaos <info@protesilaos.com>
;; URL: https://github.com/protesilaos/denote

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Tests for the Modus themes exporter Note that we are using
;; Shorthands in this file, so the "m-" prefix really is
;; "modus-themes-exporter-test-".  Evaluate the following to learn
;; more:
;;
;;    (info "(elisp) Shorthands")

;;; Code:

(require 'ert)
(require 'modus-themes-exporter)

;; All the successful conditions are covered by subsequent tests.
(ert-deftest m-modus-themes-exporter--get-theme ()
  (let ((palette (modus-themes-get-theme-palette 'modus-operandi)))
    (should-error (modus-themes-exporter--get-theme 'xterm nil))
    (should-error (modus-themes-exporter--get-theme 'unknown-application-here palette))))

;; The same test works for anything that is derived from the macro
;; `modus-themes-exporter-define-xresources'.
(ert-deftest m-modus-themes-exporter-get-alacritty ()
  "Test that `modus-themes-exporter-get-alacritty' does the right thing."
  (let ((palette (modus-themes-get-theme-palette 'modus-operandi)))
    (should-error (modus-themes-exporter-get-alacritty nil))
    (should
     (string=
      (modus-themes-exporter-get-alacritty palette)
      "[colors.bright]
black = \"#595959\"
blue = \"#3548cf\"
cyan = \"#005f5f\"
green = \"#316500\"
magenta = \"#531ab6\"
red = \"#972500\"
white = \"#ffffff\"
yellow = \"#7a4f2f\"

[colors.cursor]
cursor = \"#ffffff\"
text = \"#000000\"

[colors.normal]
black = \"#000000\"
blue = \"#0031a9\"
cyan = \"#005e8b\"
green = \"#006800\"
magenta = \"#721045\"
red = \"#a60000\"
white = \"#f2f2f2\"
yellow = \"#6f5500\"

[colors.primary]
background = \"#ffffff\"
foreground = \"#000000\"

[colors.selection]
background = \"#000000\"
text = \"#ffffff\"
"))))

(ert-deftest m-modus-themes-exporter-get-xterm ()
  "Test that `modus-themes-exporter-get-xterm' does the right thing."
  (let ((palette (modus-themes-get-theme-palette 'modus-operandi)))
    (should-error (modus-themes-exporter-get-xterm nil))
    (should
     (string=
      (modus-themes-exporter-get-xterm palette)
      "xterm*background: #ffffff
xterm*foreground: #000000
xterm*color0: #000000
xterm*color1: #a60000
xterm*color2: #006800
xterm*color3: #6f5500
xterm*color4: #0031a9
xterm*color5: #721045
xterm*color6: #005e8b
xterm*color7: #f2f2f2
xterm*color8: #595959
xterm*color9: #972500
xterm*color10: #316500
xterm*color11: #7a4f2f
xterm*color12: #3548cf
xterm*color13: #531ab6
xterm*color14: #005f5f
xterm*color15: #ffffff
"))))

(ert-deftest m-modus-themes-exporter-get-foot ()
  "Test that `modus-themes-exporter-get-foot' does the right thing."
  (let ((palette (modus-themes-get-theme-palette 'modus-operandi)))
    (should-error (modus-themes-exporter-get-foot nil))
    (should
     (string=
      (modus-themes-exporter-get-foot palette)
      "# Background and foreground
background=ffffff
foreground=000000

# Jump labels
jump-labels=000000 6f5500

# Color palette (16 colors)
regular0=000000
regular1=a60000
regular2=006800
regular3=6f5500
regular4=0031a9
regular5=721045
regular6=005e8b
regular7=f2f2f2
bright0=595959
bright1=972500
bright2=316500
bright3=7a4f2f
bright4=3548cf
bright5=531ab6
bright6=005f5f
bright7=ffffff
"))))


(ert-deftest m-modus-themes-exporter-get-ghostty ()
  "Test that `modus-themes-exporter-get-ghostty' does the right thing."
  (let ((palette (modus-themes-get-theme-palette 'modus-operandi)))
    (should-error (modus-themes-exporter-get-ghostty nil))
    (should
     (string=
      (modus-themes-exporter-get-ghostty palette)
      "# Background and foreground
background = #ffffff
foreground = #000000

# Cursor colors
cursor-color = #ffffff
cursor-text = #000000

# Selection colors
selection-background = #000000
selection-foreground = #ffffff

# Color palette (16 colors)
palette = 0=#000000
palette = 1=#a60000
palette = 2=#006800
palette = 3=#6f5500
palette = 4=#0031a9
palette = 5=#721045
palette = 6=#005e8b
palette = 7=#f2f2f2
palette = 8=#595959
palette = 9=#972500
palette = 10=#316500
palette = 11=#7a4f2f
palette = 12=#3548cf
palette = 13=#531ab6
palette = 14=#005f5f
palette = 15=#ffffff
"))))

(ert-deftest m-modus-themes-exporter-get-kitty ()
  "Test that `modus-themes-exporter-get-kitty' does the right thing."
  (let ((palette (modus-themes-get-theme-palette 'modus-operandi)))
    (should-error (modus-themes-exporter-get-kitty nil))
    (should
     (string=
      (modus-themes-exporter-get-kitty palette)
      "cursor #ffffff
cursor_text_color #000000
url_color #0031a9

active_border_color #595959
inactive_border_color #f2f2f2
bell_border_color #7a4f2f

active_tab_foreground #006800
active_tab_background #f2f2f2
inactive_tab_foreground #595959
inactive_tab_background #ffffff

foreground #000000
background #ffffff
selection_foreground #ffffff
selection_background #000000

color0 #000000
color1 #a60000
color2 #006800
color3 #6f5500
color4 #0031a9
color5 #721045
color6 #005e8b
color7 #f2f2f2
color8 #595959
color9 #972500
color10 #316500
color11 #7a4f2f
color12 #3548cf
color13 #531ab6
color14 #005f5f
color15 #ffffff
"))))

(ert-deftest m-modus-themes-exporter--output-buffer ()
  (should (bufferp (modus-themes-exporter--output-buffer "hello")))
  (should-error (modus-themes-exporter--output-buffer "hello" 'not-a-buffer-here))
  (should-error (modus-themes-exporter--output-buffer '(not correct))))

(ert-deftest m-modus-themes-exporter--output-file ()
  (let ((existing-file (make-temp-file "modus-themes-exporter-test-empty-file")))
    (cl-letf (((symbol-function 'y-or-n-p) #'ignore)) ; This is means "no" to the overwrite
      (should-not (modus-themes-exporter--output-file existing-file "hello")))
    (cl-letf (((symbol-function 'y-or-n-p) #'always)) ; This is "yes" to the overwrite
      (should (bufferp (modus-themes-exporter--output-file existing-file "hello"))))))

(provide 'modus-themes-exporter-test)
;;; modus-themes-exporter-test.el ends here

;; Local Variables:
;; read-symbol-shorthands: (("m-" . "modus-themes-exporter-test-"))
;; End:
