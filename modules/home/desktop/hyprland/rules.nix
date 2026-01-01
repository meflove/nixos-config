{
  windowRules = [
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

    "match:class com.free.clipse, center 1"
    "match:class com.free.clipse, float 1"
    "match:class com.free.clipse, size 900 652"
    "match:class com.free.clipse, stay_focused 1"
    "match:class com.free.clipse, border_size 0"

    "match:class com.free.otter-launcher, center 1"
    "match:class com.free.otter-launcher, float 1"
    "match:class com.free.otter-launcher, size 600 500"
    "match:class com.free.otter-launcher, stay_focused 1"
    "match:class com.free.otter-launcher, border_size 0"

    "match:class com.free.fsel, center 1"
    "match:class com.free.fsel, float 1"
    "match:class com.free.fsel, size 600 500"
    "match:class com.free.fsel, stay_focused 1"
    "match:class com.free.fsel, border_size 0"

    "match:class com.free.kalker, center 1"
    "match:class com.free.kalker, float 1"
    "match:class com.free.kalker, size 600 500"
    "match:class com.free.kalker, stay_focused 1"
    "match:class com.free.kalker, border_size 0"

    "match:class it.mijorus.smile, center 1"
    "match:class it.mijorus.smile, float 1"
    "match:class it.mijorus.smile, size 600 800"
    "match:class it.mijorus.smile, stay_focused 1"
    "match:class it.mijorus.smile, border_size 0"

    "match:class com.note.tjournal, center 1"
    "match:class com.note.tjournal, float 1"
    "match:class com.note.tjournal, size 1200 800"
    "match:class com.note.tjournal, stay_focused 1"
    "match:class com.note.tjournal, border_size 0"

    "match:title ^(Picture-in-Picture)$, keep_aspect_ratio 1"
    "match:title ^(Picture-in-Picture)$, move 73% 72%"
    "match:title ^(Picture-in-Picture)$, size 25%"
    "match:title ^(Picture-in-Picture)$, float 1"
    "match:title ^(Picture-in-Picture)$, pin 1"

    "match:class ^(zen-beta)$, workspace 2"
    "match:class ^(com.ayugram.desktop)$, monitor 0"

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
