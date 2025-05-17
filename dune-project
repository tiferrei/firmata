(lang dune 3.10)

(name firmata)

(generate_opam_files true)

(source
 (github modlfo/firmata))

(authors "Leonardo Laguna Ruiz" "Paul Stoffregen" "Tiago Ferreira")

(maintainers "Leonardo Laguna Ruiz")

(license GPL-3.0-only)

(documentation https://github.com/modlfo/firmata)

(package
 (name firmata)
 (synopsis "Library to control Firmata boards like Arduino.")
 (description "Library to control Firmata boards like Arduino.")
 (depends ocaml dune dune-configurator)
 (tags
  (firmata arduino esp32)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
