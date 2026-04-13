# Modus themes exporter

Export a `modus-themes` (or derivative like the `ef-themes` and the
`standard-themes`) to other applications.

The idea is to have the colours that Emacs uses be applied to your
terminal emulator or other text editor.

To make this work, call the command `modus-themes-exporter-export`.
In interactive use, it prompts for a Modus theme and then for the
application to export to.

Supported applications are listed in the value of the variable
`modus-themes-exporter-supported-applications`. I am happy to add
support for more programs: just let me know.

```elisp
(use-package modus-themes-exporter
  :ensure nil ; do not try to install because we get it from source in the `:init'
  :commands (modus-themes-exporter-export)
  :init
  ;; Then upgrade it with the command `package-vc-upgrade' or `package-vc-upgrade-all'.
  (unless (package-installed-p 'modus-themes-exporter)
    (package-vc-install "https://github.com/protesilaos/modus-themes-exporter.git")))
```

+ Git repository: <https://github.com/protesilaos/modus-themes-exporter>
+ Backronym: modus-themes... Export Xenotropically Preconfigured
  Orderly Rendered Terminal Emulator Reifications.
