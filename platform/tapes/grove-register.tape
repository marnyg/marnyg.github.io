# vhs tape: grove init + grove register (new app from scratch)
# Run via: ./tapes/render.sh grove-register
# Requires: on-cluster VPN access, grove CLI logged in.
# Creates the app at $DEMO_APP_DIR (set by render.sh) so subsequent
# tapes (pr-preview, push-to-prod) can operate on the same app.

Output demos/grove-register.gif

Set Theme "Catppuccin Mocha"
Set FontSize 18
Set Width 1200
Set Height 700
Set TypingSpeed 55ms
Set Padding 24
Set Shell bash

Hide
Type "cd $(dirname $DEMO_APP_DIR) && clear" Enter
Show

Sleep 500ms
Type "grove init $(basename $DEMO_APP_DIR)"
Sleep 300ms
Enter
Sleep 3s

Type "cd $(basename $DEMO_APP_DIR)"
Enter
Sleep 500ms

Type "ls -1"
Enter
Sleep 2s

Type "grove register"
Sleep 300ms
Enter
