# Fresh — terminal-based text editor with LSP support and TypeScript plugins
# https://github.com/sinelaw/fresh
{ ... }: {
  programs.fresh-editor = {
    enable = true;
    defaultEditor = false;
    settings = {
      version = 1;
      theme = "dark";
      editor = {
        tab_size = 4;
        use_tabs = false;
        line_numbers = true;
        line_wrap = false;
        # rulers = [ 80 120 ];
        bracket_match = true;
        trim_trailing_whitespace = true;
        ensure_final_newline = true;
        auto_save = {
          enable = true;
          after_delay_secs = 30;
        };
        format_on_save = true;
      };
      lsp_enabled = true;
      check_for_updates = false;
    };
  };
}

