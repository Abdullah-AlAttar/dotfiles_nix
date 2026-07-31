{
  programs.nixvim.autoCmd = [
    # Set terminal title to show directory when vim is open
    {
      event = ["VimEnter" "DirChanged"];
      command = ''let &titlestring = ' ' . fnamemodify(getcwd(), ':t') | if &title | set title | endif'';
    }
    {
      event = "VimLeave";
      command = "set notitle";
    }

    # Vertically center document when entering insert mode
    # {
    #   event = "InsertEnter";
    #   command = "norm zz";
    # }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex" # inria
        "latex" # inria
        "markdown"
      ];
      command = "setlocal spell spelllang=en";
    }
  ];
}
