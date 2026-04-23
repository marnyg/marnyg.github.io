# vhs tape: pull main + watch ArgoCD rollout (push to prod)
# Run via: ./tapes/render.sh push-to-prod
# Requires: DEMO_APP_DIR env pointing at a grove-registered app on main.
# render.sh enforces this — do not run `vhs` directly.

Output demos/push-to-prod.gif

Set Theme "Catppuccin Mocha"
Set FontSize 18
Set Width 1200
Set Height 700
Set TypingSpeed 55ms
Set Padding 24
Set Shell bash

Hide
Type "cd $DEMO_APP_DIR && clear" Enter
Show

Sleep 500ms
Type "git checkout main && git pull --ff-only"
Enter
Sleep 1500ms

Type "git log --oneline -3"
Enter
Sleep 2s

Type "kubectl -n $(basename $DEMO_APP_DIR) rollout status deploy/$(basename $DEMO_APP_DIR) --watch"
Sleep 300ms
Enter
Sleep 20s
