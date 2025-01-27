scoped: {
  lib,
  pkgs,
  ...
}: let
  # Define the shell script that interacts with `hyprctl` and retrieves monitor data
  parseMonitors = pkgs.writeTextFile {
    name = "parseMonitors.sh";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      monitors=$(hyprctl monitors all | grep Monitor | awk 'END {print NR}')
      monitorNames=$(hyprctl monitors all | grep Monitor | awk '{print $2}')
      resolutions=$(hyprctl monitors all | grep ' at ' | awk '{print $1}')
      positions=$(hyprctl monitors all | grep ' at ' | awk '{print $3}')
      scales=$(hyprctl monitors all | grep 'scale' | awk '{print $2}')

      get_monitor_data() {
      	local monitor_index=$1
      	local attribute=$2

      	case "$attribute" in
      		name)
      			echo "\$\{monitorNames[$monitor_index]\}"
      			;;
      		resolution)
      			echo "\$\{resolutions[$monitor_index]\}"
      			;;
      		position)
      			echo "\$\{positions[$monitor_index]\}"
      			;;
      		scale)
      			echo "\$\{scales[$monitor_index]\}"
      			;;
      		*)
      			echo "Invalid attribute: $attribute"
      			exit 1
      			;;
      	esac
      }

      handle_case() {
      	local action=$1
      	if [ "$action" == "count" ]; then
      		# Return the count of monitors
      		echo "$monitors"
      	elif [ $# -eq 2 ]; then
      		# If 2 arguments are provided (monitor index and attribute), return the requested attribute
      		local monitor_index=$1
      		local attribute=$2
      		get_monitor_data "$monitor_index" "$attribute"
      	else
      		# Handle invalid arguments
      		echo "Usage: $0 {count | monitor_index attribute}"
      		exit 1
      	fi
      }
    '';
  } |> builtins.readFile;

  callAttr = attr: monitorIndex: builtins.exec ["bash" "-c" "${parseMonitors}" "--" "${monitorIndex}" "${attr}"];

  monitorCount = builtins.exec ["bash" "-c" "${parseMonitors}" "--" "count"];

  formattedOutput = monitorIndex: {
    "${monitorIndex}" = {
      name = callAttr "name" monitorIndex;
      resolution = callAttr "resolution" monitorIndex;
      position = callAttr "position" monitorIndex;
      refreshRate = callAttr "refreshRate" monitorIndex;
      scale = callAttr "scale" monitorIndex;
    };
  };

  monitorsList = lib.genList (i: formattedOutput i) monitorCount;

  mergedMonitorsList = lib.attrsets.mergeAttrsList monitorsList;
in
  mergedMonitorsList
