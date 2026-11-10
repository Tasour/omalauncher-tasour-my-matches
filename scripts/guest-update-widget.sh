#!/system/bin/sh
# À lancer dans le terminal invité d'Omalauncher (pas sur le PC).
# Remplace le widget partagé par la version optimisée, sans ADB.
set -u
DIR="$HOME/.config/omalauncher/widgets"
cd "$DIR" || { echo "no widgets dir"; exit 1; }
command -v perl >/dev/null 2>&1 || pacman -S --noconfirm perl
f=$(grep -l 'My Matches' *.owl 2>/dev/null | head -1)
f=${f:-shared-my-matches-football.owl}
echo "target=$f"
URL1="https://raw.githubusercontent.com/Tasour/omalauncher-my-match/main/widget/my-match.optimized.owl"
BASE="${OMA_BASE:-}"
if [ -z "$BASE" ] && [ -r "$HOME/.config/omalauncher/measure-base" ]; then
  BASE=$(head -n 1 "$HOME/.config/omalauncher/measure-base" 2>/dev/null | tr -d '\r')
fi
BASE=$(printf '%s' "$BASE" | tr -d '\r\n')
printf '%s' "$BASE" | grep -Ex '^https?://[A-Za-z0-9._:-]+$' || BASE="http://127.0.0.1:1764"
URL2="$BASE/widget/my-match.optimized.owl"
if ! curl -fsSL --connect-timeout 10 --url "$URL1" -o .my-match.new; then
  echo "GitHub failed, trying local server..."
  curl -fsSL --connect-timeout 10 --url "$URL2" -o .my-match.new || true
fi
if [ -s .my-match.new ] && grep -q 'widget"' .my-match.new; then
  mv .my-match.new "$f"
  echo UPDATED
  grep -o 'version:"[^"]*"' "$f" | head -1
  command -v owl-check >/dev/null 2>&1 && owl-check "$f" | head -20
else
  echo "DOWNLOAD FAILED"
  rm -f .my-match.new
fi
URL3="https://raw.githubusercontent.com/Tasour/omalauncher-my-match/main/scripts/nat-crests.sh"
URL4="$BASE/scripts/nat-crests.sh"
if ! curl -fsSL --connect-timeout 10 --url "$URL3" -o .nat-crests.new; then
  curl -fsSL --connect-timeout 10 --url "$URL4" -o .nat-crests.new || true
fi
if [ -s .nat-crests.new ]; then
  mv .nat-crests.new nat-crests.sh
  chmod 700 nat-crests.sh
fi
