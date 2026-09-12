{...}: {
  programs.herdr = {
    enable = true;
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
        toast.delivery = "terminal";
      };
    };
  };
}
