# This module exposes what oh-my-opencode injects into opencode's configuration.
{
  pkgs,
  config,
  lib,
  ...
}: let
  omo-configs = args: let
    rawfiles = pkgs.stdenvNoCC.mkDerivation {
      pname = "omo-configs";
      inherit (args) version;

      src = null;

      buildInputs = with pkgs; [bun args.opencode];

      buildPhase = ''
        mkdir -p $out

        HOME=$TMPDIR bunx oh-my-opencode@${args.version} install \
          --no-tui \
          --claude=${args.claude} \
          --openai=${args.openai} \
          --gemini=${args.gemini} \
          --copilot=${args.copilot} \
          --opencode-zen=${args.opencode-zen} \
          --zai-coding-plan=${args.zai-coding-plan} \
          --kimi-for-coding=${args.kimi-for-coding} \
          --skip-auth

        mv $TMPDIR/.config/opencode/opencode.json $out/opencode.json
        mv $TMPDIR/.config/opencode/oh-my-opencode.json $out/oh-my-opencode.json
      '';
    };
    inherit (builtins) readFile;
    readJson = path: builtins.fromJSON (builtins.readFile path);
  in {
    opencode-raw = readFile "${rawfiles}/opencode.json";
    omo-raw = readFile "${rawfiles}/oh-my-opencode.json";

    opencode = readJson "${rawfiles}/opencode.json";
    omo = readJson "${rawfiles}/oh-my-opencode.json";
  };
  # map true to "yes" and false to "no"
  convertToCliArgs = let
    bool2str = v:
      if builtins.isBool v
      then
        (
          if v
          then "yes"
          else "no"
        )
      else v;
  in
    lib.mapAttrs (_: bool2str);
in {
  options = {
    programs.agents.plugins.oh-my-opencode = {
      enable = lib.mkEnableOption "Inject oh-my-opencode configuration into opencode";

      version = lib.mkOption {
        type = lib.types.str;
        default = "latest";
      };

      claude = lib.mkOption {
        type = lib.types.enum [true false "max20"];
        default = false;
      };
      openai = lib.mkOption {
        type = lib.types.enum [true false];
        default = false;
      };
      gemini = lib.mkOption {
        type = lib.types.enum [true false];
        default = false;
      };
      copilot = lib.mkOption {
        type = lib.types.enum [true false];
        default = false;
      };
      opencode-zen = lib.mkOption {
        type = lib.types.enum [true false];
        default = false;
      };
      zai-coding-plan = lib.mkOption {
        type = lib.types.enum [true false];
        default = false;
      };
      kimi-for-coding = lib.mkOption {
        type = lib.types.enum [true false];
        default = false;
      };
    };
  };

  config = let
    cfg = config.programs.agents.plugins.oh-my-opencode;
  in
    lib.mkIf cfg.enable (
      let
        omo-cfg = omo-configs (convertToCliArgs cfg // {opencode = config.programs.opencode.package;});
      in {
        programs.opencode = {
          settings = omo-cfg.opencode;
        };
        xdg.configFile."opencode/oh-my-opencode.json".text = omo-cfg.omo-raw;
      }
    );
}
