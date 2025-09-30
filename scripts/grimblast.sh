#!/usr/bin/env bash
## Grimblast: помощник для скриншотов в Hyprland

resetFade() {
  if [[ -n $FADE && -n $FADEOUT ]]; then
    hyprctl keyword animation "$FADE" >/dev/null
    hyprctl keyword animation "$FADEOUT" >/dev/null
  fi
}

killHyprpicker() {
  if [ $HYPRPICKER_PID -gt 0 ]; then
    kill $HYPRPICKER_PID 2>/dev/null
    HYPRPICKER_PID=-1
  fi
}

trap 'resetFade; killHyprpicker' EXIT

getTargetDirectory() {
  test -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" &&
    . "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"

  echo "${XDG_SCREENSHOTS_DIR:-${XDG_PICTURES_DIR:-$HOME}}"
}

tmp_editor_directory() {
  echo "/tmp"
}

env_editor_confirm() {
  if [ -n "$GRIMBLAST_EDITOR" ]; then
    return
  fi

  if [ -n "$VISUAL" ]; then
    GRIMBLAST_EDITOR="$VISUAL"
  elif [ -n "$EDITOR" ]; then
    GRIMBLAST_EDITOR="$EDITOR"
  else
    GRIMBLAST_EDITOR=gimp
  fi
}

NOTIFY=yes
HIDE_CURSOR=
FREEZE=yes
WAIT=no
SCALE=
HYPRPICKER_PID=-1

while [ $# -gt 0 ]; do
  key="$1"

  case $key in
  -n | --notify)
    NOTIFY=yes
    shift
    ;;
  -h | --hide-cursor)
    HIDE_CURSOR=yes
    shift
    ;;
  -f | --freeze)
    FREEZE=yes
    shift
    ;;
  -w | --wait)
    shift
    WAIT=$1
    if echo "$WAIT" | grep "[^0-9]" -q; then
      echo "Неверное значение для --wait '$WAIT'" >&2
      exit 3
    fi
    shift
    ;;
  -s | --scale)
    shift
    if [ $# -gt 0 ]; then
      SCALE="$1"
      shift
    else
      echo "Ошибка: отсутствует значение для --scale"
      exit 1
    fi
    ;;
  *)
    break
    ;;
  esac
done

ACTION=${1:-usage}
SUBJECT=${2:-screen}
FILE=${3:-$(getTargetDirectory)/$(date -Ins).png}

if [ "$ACTION" = "edit" ]; then
  FILE_EDITOR=${3:-$(mktemp -p "$(tmp_editor_directory)" grimblast_XXXXXXXXXX.png)}
fi

if [ "$ACTION" = "save" ] || [ "$ACTION" = "copysave" ] || [ "$ACTION" = "edit" ]; then
  if [ "$FILE" != "-" ]; then
    DIR=$(dirname "$FILE")
    if [ ! -d "$DIR" ]; then
      mkdir -p "$DIR" || die "Невозможно создать директорию: $DIR"
    fi
  fi
fi

[ "$ACTION" = "usage" ] && {
  echo "Использование:"
  echo "  grimblast [--notify] [--hide-cursor] [--freeze] [--wait N] [--scale <scale>] (copy|save|copysave|edit) [active|screen|output|area] [FILE|-]"
  echo "  grimblast check"
  echo "  grimblast usage"
  echo ""
  echo "Команды:"
  echo "  copy: Скопировать в буфер обмена"
  echo "  save: Сохранить в файл"
  echo "  copysave: Скопировать и сохранить"
  echo "  edit: Открыть в редакторе (по умолчанию gimp)"
  echo "  check: Проверить зависимости"
  exit
}

notify() {
  notify-send -t 3000 -a grimblast "$@"
}

notifyOk() {
  [ "$NOTIFY" = "no" ] && return
  notify "$@"
}

notifyError() {
  if [ "$NOTIFY" = "yes" ]; then
    TITLE=${2:-"Скриншот"}
    MESSAGE=${1:-"Ошибка создания скриншота"}
    notify -u critical "$TITLE" "$MESSAGE"
  else
    echo "$1" >&2
  fi
}

die() {
  MSG=${1:-"Прервано"}
  notifyError "Ошибка: $MSG"
  exit 2
}

check() {
  COMMAND=$1
  if command -v "$COMMAND" >/dev/null 2>&1; then
    RESULT="OK"
  else
    RESULT="НЕ НАЙДЕНО"
  fi
  echo "   $COMMAND: $RESULT"
}

takeScreenshot() {
  local file=$1
  local geom=$2
  local output=$3

  local cmd=(grim)

  [ -n "$HIDE_CURSOR" ] && cmd+=(-c)
  [ -n "$SCALE" ] && cmd+=(-s "$SCALE")
  [ -n "$output" ] && cmd+=(-o "$output")

  if [ -n "$geom" ]; then
    local coords=${geom%% *}
    local dimensions=${geom##* }

    if ! echo "$coords" | grep -Eq '^[0-9]+,[0-9]+$' ||
      ! echo "$dimensions" | grep -Eq '^[0-9]+x[0-9]+$'; then
      die "Неверная геометрия: $geom"
    fi

    cmd+=(-g "$geom")
  fi

  cmd+=("$file")

  "${cmd[@]}" || die "Ошибка grim"
}

wait() {
  [ "$WAIT" = "no" ] && return
  sleep "$WAIT"
}

if [ "$ACTION" = "check" ]; then
  echo "Проверка зависимостей:"
  check grim
  check slurp
  check hyprctl
  check hyprpicker
  check wl-copy
  check jq
  check notify-send
  exit
fi

wait

case "$SUBJECT" in
active)
  FOCUSED=$(hyprctl activewindow -j)
  GEOM=$(echo "$FOCUSED" | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
  APP_ID=$(echo "$FOCUSED" | jq -r '.class')
  WHAT="$APP_ID окно"
  ;;

screen)
  GEOM=""
  WHAT="Весь экран"
  ;;

output)
  OUTPUT=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
  WHAT="$OUTPUT"
  ;;

area)
  if [ "$FREEZE" = "yes" ] && command -v hyprpicker >/dev/null; then
    hyprpicker -r -z &
    HYPRPICKER_PID=$!
    sleep 0.2 # Даем время на инициализацию
  fi

  FADE="$(hyprctl -j animations | jq -jr '.[0][] | select(.name == "fade") | .name, ",", (.enabled|tostring), ",", (.speed|tostring), ",", .bezier')"
  FADEOUT="$(hyprctl -j animations | jq -jr '.[0][] | select(.name == "fadeOut") | .name, ",", (.enabled|tostring), ",", (.speed|tostring), ",", .bezier')"
  hyprctl keyword animation 'fade,0,1,default' >/dev/null
  hyprctl keyword animation 'fadeOut,0,1,default' >/dev/null

  WORKSPACES="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
  WINDOWS="$(hyprctl clients -j | jq -r --argjson workspaces "$WORKSPACES" 'map(select([.workspace.id] | inside($workspaces)))')"
  GEOM=$(echo "$WINDOWS" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)

  [ -z "$GEOM" ] && exit 1 # Пользователь отменил выбор
  WHAT="Область"

  killHyprpicker
  ;;

*)
  die "Неподдерживаемый объект: $SUBJECT"
  ;;
esac

# Основные действия -----------------------------------------------------------

case "$ACTION" in
copy)
  takeScreenshot - "$GEOM" "$OUTPUT" | wl-copy --type image/png || die "Ошибка буфера обмена"
  notifyOk "$WHAT скопировано"
  ;;

save)
  if takeScreenshot "$FILE" "$GEOM" "$OUTPUT"; then
    notifyOk "Скриншот $SUBJECT сохранён" "$(basename "$FILE")" -i "$FILE"
    echo "$FILE"
  fi
  ;;

edit)
  env_editor_confirm
  if takeScreenshot "$FILE_EDITOR" "$GEOM" "$OUTPUT"; then
    notifyOk "Скриншот готов к редактированию" "$(basename "$FILE_EDITOR")" -i "$FILE_EDITOR"
    "$GRIMBLAST_EDITOR" "$FILE_EDITOR" || die "Не удалось запустить редактор: $GRIMBLAST_EDITOR"
    echo "$FILE_EDITOR"
  fi
  ;;

copysave)
  takeScreenshot - "$GEOM" "$OUTPUT" | tee "$FILE" | wl-copy --type image/png || die "Ошибка"
  notifyOk "$WHAT сохранено и скопировано" "$(basename "$FILE")" -i "$FILE"
  echo "$FILE"
  ;;
esac
