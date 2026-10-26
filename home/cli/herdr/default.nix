{...}: {
  programs.herdr = {
    enable = true;
    mutableSettings = true;
    settings = {
      onboarding = false;
      theme = {
        name = "terminal";
        auto_switch = false;
      };
      ui = {
        agent_panel_sort = "spaces";
        show_agent_labels_on_pane_borders = true;
        host_cursor = "native";
        tab_bar_position = "top";
        toast.delivery = "terminal";
        window_title = "🐂 herdr: {workspace}";
      };
    };
  };
}
