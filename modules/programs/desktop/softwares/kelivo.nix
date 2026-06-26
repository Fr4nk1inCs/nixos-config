{
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = [
        pkgs.kelivo
      ];

      targets = lib.optionalAttrs pkgs.stdenv.isDarwin {
        darwin.defaults."com.psyche.kelivo" = {
          "flutter.user_name" = config.home.username;
          "flutter.avatar_type" = "url";
          "flutter.avatar_value" =
            "https://q2.qlogo.cn/headimg_dl?dst_uin=1145158903&spec=100";
          "flutter.desktop_sidebar_open_v1" = 1;
          "flutter.desktop_topic_position_v1" = "left";
          "flutter.display_desktop_show_tray_v1" = 0;
          "flutter.display_show_model_icon_v1" = 0;
          "flutter.display_show_provider_in_chat_message_v1" = 1;
          "flutter.display_show_provider_in_model_capsule_v1" = 1;
          "flutter.display_show_user_avatar_v1" = 0;
          "flutter.display_show_user_name_v1" = 0;
          "flutter.display_use_pure_background_v1" = 1;
        };
      };
    };
}
