{
  default = ''
    layout {
    //    pane size=1 borderless=true {
    //         plugin location="zjstatus" {
    //             format_left "{mode}#[bg=#222436] {tabs}"
    //             format_center ""
    //             format_right "#[bg=#222436,fg=#89b4fa]#[bg=#89b4fa,fg=#1e2030,bold] #[bg=#363a4f,fg=#89b4fa,bold] {session} #[bg=#181926,fg=#363a4f,bold]"
    //             format_space ""
    //             format_hide_on_overlength "true"
    //             format_precedence "crl"
    //             border_enabled "false"
    //             border_char "─"
    //             border_format "#[fg=#6C7086]{char}"
    //             border_position "top"
    //             mode_normal "#[bg=#a6da95,fg=#222436,bold] NORMAL#[bg=#222436,fg=#a6da95]"
    //             mode_locked "#[bg=#6e738d,fg=#222436,bold] LOCKED #[bg=#222436,fg=#6e738d]"
    //             mode_resize "#[bg=#f38ba8,fg=#222436,bold] RESIZE#[bg=#222436,fg=#f38ba8]"
    //             mode_pane "#[bg=#89b4fa,fg=#222436,bold] PANE#[bg=#222436,fg=#89b4fa]"
    //             mode_tab "#[bg=#b4befe,fg=#222436,bold] TAB#[bg=#222436,fg=#b4befe]"
    //             mode_scroll "#[bg=#f9e2af,fg=#222436,bold] SCROLL#[bg=#222436,fg=#f9e2af]"
    //             mode_enter_search "#[bg=#8aadf4,fg=#222436,bold] ENT-SEARCH#[bg=#222436,fg=#8aadf4]"
    //             mode_search "#[bg=#8aadf4,fg=#222436,bold] SEARCHARCH#[bg=#222436,fg=#8aadf4]"
    //             mode_rename_tab "#[bg=#b4befe,fg=#222436,bold] RENAME-TAB#[bg=#222436,fg=#b4befe]"
    //             mode_rename_pane "#[bg=#89b4fa,fg=#222436,bold] RENAME-PANE#[bg=#222436,fg=#89b4fa]"
    //             mode_session "#[bg=#74c7ec,fg=#222436,bold] SESSION#[bg=#222436,fg=#74c7ec]"
    //             mode_move "#[bg=#f5c2e7,fg=#222436,bold] MOVE#[bg=#222436,fg=#f5c2e7]"
    //             mode_prompt "#[bg=#8aadf4,fg=#222436,bold] PROMPT#[bg=#181926,fg=#8aadf4]"
    //             mode_tmux "#[bg=#f5a97f,fg=#222436,bold] TMUX#[bg=#181926,fg=#f5a97f]"
    //             // formatting for inactive tabs
    //             tab_normal "#[bg=#222436,fg=#89b4fa]#[bg=#89b4fa,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#89b4fa,bold] {name}{floating_indicator}#[bg=#181926,fg=#363a4f,bold]█"
    //             tab_normal_fullscreen "#[bg=#222436,fg=#89b4fa]#[bg=#89b4fa,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#89b4fa,bold] {name}{fullscreen_indicator}#[bg=#181926,fg=#363a4f,bold]█"
    //             tab_normal_sync "#[bg=#222436,fg=#89b4fa]#[bg=#89b4fa,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#89b4fa,bold] {name}{sync_indicator}#[bg=#181926,fg=#363a4f,bold]█"
    //             // formatting for the current active tab
    //             tab_active "#[bg=#222436,fg=#fab387]#[bg=#fab387,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#fab387,bold] {name}{floating_indicator}#[bg=#181926,fg=#363a4f,bold]█"
    //             tab_active_fullscreen "#[bg=#222436,fg=#fab387]#[bg=#fab387,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#fab387,bold] {name}{fullscreen_indicator}#[bg=#181926,fg=#363a4f,bold]█"
    //             tab_active_sync "#[bg=#222436,fg=#fab387]#[bg=#fab387,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#fab387,bold] {name}{sync_indicator}#[bg=#181926,fg=#363a4f,bold]█"
    //             // separator between the tabs
    //             tab_separator "#[bg=#222436] "
    //             // indicators
    //             tab_sync_indicator " "
    //             tab_fullscreen_indicator " 󰊓"
    //             tab_floating_indicator " 󰹙"
    //             command_git_branch_command "git rev-parse --abbrev-ref HEAD"
    //             command_git_branch_format "#[fg=blue] {stdout} "
    //             command_git_branch_interval "10"
    //             command_git_branch_rendermode "static"
    //             datetime "#[fg=#6C7086,bold] {format} "
    //             datetime_format "%A, %d %b %Y %H:%M"
    //             datetime_timezone "Asia/Krasnoyarsk"
    //         }
    //     }
    //     pane {
    //         borderless true
    //         focus true
    //     }
        pane size=2 borderless=true {
            plugin location="zjstatus" {
                color_bg1 "#5b6078" //dark1
                color_fg1 "#cad3f5" //light1
                color_orange "#fab387" //bright_orange

                color_base "#232136"
                color_surface "#2a273f"
                color_overlay "#393552"
                color_muted "#6e6a86"
                color_subtle "#908caa"
                color_text "#c8d3f5"
                color_love "#eb6f92"
                color_gold "#f6c177"
                color_rose "#ea9a97"
                color_pine "#3e8fb0"
                color_foam "#9ccfd8"
                color_Iris "#c4a7e7"
                color_highlight_low "#2a283e"
                color_highlight_med "#44415a"
                color_highlight_high "#56526e"


                format_left   "#[fg=$text] {session} {mode}#[]"
                format_center "{tabs}"
                format_right  "{datetime} "
                format_space  "#[fg=$fg1]"
                format_hide_on_overlength "true"
                format_precedence "lrc"

                border_enabled  "false"
                border_char     "─"
                border_format   "#[fg=$bg1]{char}"
                border_position "top"

                hide_frame_for_single_pane "false"

                mode_normal        "#[fg=$text] NORMAL "
                mode_locked        "#[fg=$muted] LOCKED "
                mode_pane          "#[fg=$pine,bold] PANE "
                mode_tab           "#[fg=$rose,bold] TAB "
                mode_scroll        "#[fg=$foam,bold] SCROLL "
                mode_enter_search  "#[fg=$text,bold] ENT-SEARCH "
                mode_search        "#[fg=$subtle,bold] SEARCH "
                mode_resize        "#[fg=$gold,bold] RESIZE "
                mode_rename_tab    "#[fg=$gold,bold] RENAME TAB "
                mode_rename_pane   "#[fg=$gold,bold] RENAME PANE "
                mode_move          "#[fg=$gold,bold] MOVE "
                mode_session       "#[fg=$love,bold] SESSION "
                mode_prompt        "#[fg=$love,bold] PROMPT "

                tab_normal              "#[fg=$subtle] {index} #[fg=$subtle] {name} {floating_indicator} "
                tab_normal_fullscreen   "#[fg=$subtle] {index} #[fg=$subtle] {name} {fullscreen_indicator} "
                tab_normal_sync         "#[fg=$subtle] {index} #[fg=$subtle] {name} {sync_indicator} "
                tab_active              "#[bg=$overlay,fg=$text] {index} #[bg=$overlay,fg=$text,bold] {name} {floating_indicator} "
                tab_active_fullscreen   "#[bg=$overlay,fg=$text] {index} #[bg=$overlay,fg=$text,bold] {name} {fullscreen_indicator} "
                tab_active_sync         "#[bg=$overlay,fg=$text] {index} #[bg=$overlay,fg=$text,bold] {name} {sync_indicator} "
                tab_separator           " "

                tab_sync_indicator       ""
                tab_fullscreen_indicator "󰊓"
                tab_floating_indicator   "󰹙"

                notification_format_unread "#[bg=$orange,fg=$bg1]#[bg=$orange,fg=$bg1] {message} #[bg=$bg1,fg=$orange]"
                notification_format_no_notifications ""
                notification_show_interval "10"

                command_host_command    "uname -n"
                command_host_format     "{stdout}"
                command_host_interval   "0"
                command_host_rendermode "static"

                command_user_command    "whoami"
                command_user_format     "{stdout}"
                command_user_interval   "0"
                command_user_rendermode "static"

                datetime          "#[fg=$text] {format}"
                datetime_format   "%Y-%m-%d %H:%M"
                datetime_timezone "Asia/Barnaul"
            }
        }
        pane {
            borderless true
            focus true
        }
    }
  '';
}
