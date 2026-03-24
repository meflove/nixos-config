let
  makeFloatingWindowRules = class: width: height: [
    "match:class ${class}, center 1"
    "match:class ${class}, float 1"
    "match:class ${class}, size ${toString width} ${toString height}"
    "match:class ${class}, stay_focused 1"
    "match:class ${class}, border_size 0"
  ];
in {
  # Функция для генерации правил центрируемых плавающих окон
  # class: класс окна (например, "com.free.kalker")
  # width: ширина окна (например, 600)
  # height: высота окна (например, 500)

  windowRules =
    [
      # "opacity 0.89 override 0.89 override, title:^(.*)$"
      "match:title ^(blueberry.py)$, float 1"
      "match:title ^(steam)$, float 1"
      "match:title ^(guifetch)$, float 1"
      "match:title ^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$, tile 1"
      "match:title ^(Open File)(.*)$, center 1"
      "match:title ^(Open File)(.*)$, float 1"
      "match:title ^(Select a File)(.*)$, center 1"
      "match:title ^(Select a File)(.*)$, float 1"
      "match:title ^(Choose wallpaper)(.*)$, center 1"
      "match:title ^(Choose wallpaper)(.*)$, float 1"
      "match:title ^(Open Folder)(.*)$, center 1"
      "match:title ^(Open Folder)(.*)$, float 1"
      "match:title ^(Save As)(.*)$, center 1"
      "match:title ^(Save As)(.*)$, float 1"
      "match:title ^(Library)(.*)$, center 1"
      "match:title ^(Library)(.*)$, float 1"
      "match:title ^(File Upload)(.*)$, center 1"
      "match:title ^(File Upload)(.*)$, float 1"
      "match:title ^(Extract)(.*)$, center 1"
      "match:title ^(Extract)(.*)$, float 1"
      "match:title ^(Wine configuration)(.*)$, center 1"
      "match:title ^(Wine configuration)(.*)$, float 1"
      "match:title ^(Blobdrop)(.*)$, center 1"
      "match:title ^(Blobdrop)(.*)$, float 1"
    ]
    ++ makeFloatingWindowRules "com.free.clipse" 900 650
    ++ makeFloatingWindowRules "com.free.otter-launcher" 600 500
    ++ makeFloatingWindowRules "com.free.fsel" 600 500
    ++ makeFloatingWindowRules "com.free.kalker" 600 500
    ++ makeFloatingWindowRules "it.mijorus.smile" 600 800
    ++ makeFloatingWindowRules "com.free.bluetui" 900 750
    ++ [
      "match:title ^(Picture-in-Picture)$, keep_aspect_ratio 1"
      "match:title ^(Picture-in-Picture)$, move 73% 72%"
      "match:title ^(Picture-in-Picture)$, size 25%"
      "match:title ^(Picture-in-Picture)$, float 1"
      "match:title ^(Picture-in-Picture)$, pin 1"

      "match:class ^(zen-beta)$, workspace 2"
      "match:class ^(com.ayugram.desktop)$, monitor 0"
      "match:class ^(SoundCloud Desktop)$, workspace special"

      "match:title ^(.*\\.exe)$, immediate 1"
      "match:class (steam_app), immediate 1"

      "match:float no, no_shadow 1"
      "match:pin yes, border_color rgba(C6C5D6AA) rgba(C6C5D677)"
    ];

  layerRules = [
    "match:namespace .*, xray 1"
    "match:namespace selection, no_anim 1"
    "match:namespace hyprpicker, no_anim 1"
    "match:namespace ^(dms)$, no_anim 1"

    "match:namespace shell:*, ignore_alpha 0.6,"
    "match:namespace gtk-layer-shell, blur 1"
  ];
}
