{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubectx
    stern
    sops
    # argocd
    kubecolor
    kubernetes-helm
    helm-docs
    hadolint
    trivy
    # fblog
    # bunyan-rs
    # pino-pretty
    # jsonlog
  ];

  programs.zsh.initContent = ''
    source <(kubectl completion zsh)
  '';
}
