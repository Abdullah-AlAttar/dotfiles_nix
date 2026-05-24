{
  stern = {
    shortCut = "Ctrl-Y";
    confirm = false;
    description = "Logs <Stern>";
    scopes = ["pods"];
    command = "stern";
    background = false;
    args = [
      "--tail"
      "50"
      "$FILTER"
      "-n"
      "$NAMESPACE"
      "--context"
      "$CONTEXT"
    ];
  };

  yamlLogs = {
    shortCut = "Shift-Y";
    confirm = false;
    description = "Logs (as YAML)";
    scopes = [
      "daemonset"
      "deploy"
      "job"
      "pod"
      "replicaset"
      "service"
      "statefulset"
    ];
    command = "sh";
    background = false;
    args = [
      "-c"
      ''kubectl logs --context="$CONTEXT" --namespace="$NAMESPACE" "$RESOURCE_NAME/$NAME" | jq -cR ". as \$line | try (fromjson | .) catch \$line" | yq --input-format="json" --colors "''${1:-.}" - | less -R''
    ];
  };
  humanlog-container = {
    shortCut = "Shift-L";
    confirm = false;
    description = "humanlog";
    scopes = ["containers"];
    command = "sh";
    background = false;
    args = [
      "-c"
      "kubectl logs --follow -n $NAMESPACE $POD -c $NAME | humanlog"
    ];
  };
}
