# vhs tape: grove init + grove register (new app from scratch)
# Run via: ./tapes/render.sh grove-register
# Requires: on-cluster VPN access, grove CLI logged in.
# Uses a timestamped app name so repeat runs don't collide in the registry.

Output demos/grove-register.gif

Set Theme "Catppuccin Mocha"
Set FontSize 18
Set Width 1200
Set Height 700
Set TypingSpeed 55ms
Set Padding 24
Set Shell bash

Hide
Type "cd $(mktemp -d) && export APP=demo-$(date +%s) && clear" Enter
Show

Sleep 500ms
Type "grove init $APP"
Sleep 300ms
Enter
Sleep 3s

Type "cd $APP"
Enter
Sleep 500ms

Type "ls -1"
Enter
Sleep 2s

Type "grove register"
Sleep 300ms
Enter
Sleep 30s
