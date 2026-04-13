;;; modus-themes-exporter-test.el --- Unit tests for the Modus themes exporter -*- lexical-binding: t -*-

;; Copyright (C) 2026  Protesilaos Stavrou

;; Author: Protesilaos Stavrou <info@protesilaos.com>
;; Maintainer: Protesilaos Stavrou <info@protesilaos.com>
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

(ert-deftest m-modus-themes-exporter--output-buffer ()
  (should (bufferp (modus-themes-exporter--output-buffer "hello")))
  (should-error (modus-themes-exporter--output-buffer "hello" 'not-a-buffer-here))
  (should-error (modus-themes-exporter--output-buffer '(not correct))))

(ert-deftest m-modus-themes-exporter--output-file ()
  (let ((existing-file (make-temp-file "modus-themes-exporter-test-empty-file")))
    (cl-letf (((symbol-function 'y-or-n-p) #'ignore)) ; This is "no" to the overwrite
      (should-not (modus-themes-exporter--output-file existing-file "hello")))
    (cl-letf (((symbol-function 'y-or-n-p) #'always)) ; This is "yes" to the overwrite
      (should (bufferp (modus-themes-exporter--output-file existing-file "hello"))))))

(provide 'modus-themes-exporter-test)
;;; modus-themes-exporter-test.el ends here

;; Local Variables:
;; read-symbol-shorthands: (("m-" . "modus-themes-exporter-test-"))
;; End:
