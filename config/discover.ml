module C = Configurator.V1

let () =
  C.main ~name:"flags" (fun c ->
    let flags = [] in
    let flags = match (C.ocaml_config_var c "system") with
      | Some "macosx" -> flags @ ["-DMACOSX"]
      | _ -> flags in
    let flags = match Sys.getenv_opt "NIX_CFLAGS_COMPILE" with
      | Some nix -> flags @ (C.Flags.extract_blank_separated_words nix)
      | _ -> flags in
    C.Flags.write_sexp "flags.sexp" flags);
  C.main ~name:"c_library_flags" (fun c ->
    let flags = [] in
    let flags = match (C.ocaml_config_var c "system") with
      | Some "macosx" -> flags @ ["-lstdc++"; "-framework"; "CoreFoundation"; "-framework"; "IOKit"]
      | _ -> flags in
    C.Flags.write_sexp "c_library_flags.sexp" flags)

