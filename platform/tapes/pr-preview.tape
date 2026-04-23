# vhs tape: branch + grove pr (PR preview environments)
# Run via: ./tapes/render.sh pr-preview
# Requires: DEMO_APP_DIR env pointing at a grove-registered app with a
# clean working tree. render.sh enforces this — do not run `vhs` directly.
# Each run creates a timestamped branch so re-runs don't collide.

Output demos/pr-preview.gif

Set Theme "Catppuccin Mocha"
Set FontSize 18
Set Width 1200
Set Height 700
Set TypingSpeed 55ms
Set Padding 24
Set Shell bash

Hide
Type "cd $DEMO_APP_DIR && export BR=feature/preview-$(date +%s) && clear" Enter
Show

Sleep 500ms
Type "git checkout -b $BR"
Enter
Sleep 1s

Type `sed -i '' 's/Hello/Hi there/' main.go`
Enter
Sleep 500ms

Type "git add main.go && git commit -m 'friendlier copy'"
Enter
Sleep 1s

Type "grove pr --title 'friendlier copy'"
Sleep 300ms
Enter
Sleep 12s
