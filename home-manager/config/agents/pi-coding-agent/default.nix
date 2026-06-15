{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.pi-coding-agent;

  jsonFormat = pkgs.formats.json { };

  isStorePathString =
    content: builtins.isString content && lib.hasPrefix "${builtins.storeDir}/" content;
  isPathLikeContent = content: lib.isPath content || isStorePathString content;
in
{
  options = {
    programs.pi-coding-agent = {
      skills = lib.mkOption {
        type = lib.types.either (lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.lines
            lib.types.path
            lib.types.str
          ]
        )) lib.types.path;
        default = { };
        description = ''
          Custom skills for Opencode.

          This option can be either:
          - An attribute set defining skills
          - A path to a directory containing skill folders

          If an attribute set iis used, the attribute name becomes the skill
          directory name, and the value is either:
          - Inline content as a string (creates `skills/<name>/SKILL.md`)
          - A path to a file (creates `skills/<name>/SKILL.md`)
          - A path to a directory (creates `skills/<name>/` with all files)

          This also accepts Nix store paths, for example a skill directory from
          a package.

          If a path is used, it is expected to contain one folder per skill
          name, each containing a {file}`SKILL.md`. The directory is symlinked
          to {file}`$HOME/.pi/agent/skills/`.

          See <https://pi.dev/docs/latest/skills> for more details.
        '';
      };

      extensions = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.lines
            lib.types.path
            lib.types.str
          ]
        );
        default = { };
        description = ''
          Custom extensions for pi-coding-agent.

          The attribute name becomes the extension filename, and the value is either:
          - Inline content as a string (creates `extensions/<name>.ts`)
          - A path to a file (creates `extensions/<name>.ts`)

          The configured extensions are written to
          {file}`$HOME/.pi/agent/extensions/` with one file per extension.

          See <https://pi.dev/docs/latest/extensions> for more details.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file =
      let
        prefix = cfg.configDir;
        linkOrCreate =
          content:
          if isPathLikeContent content then
            { source = content; }
          else if content != "" then
            { text = content; }
          else
            { enable = false; };

        buildNamedDirectory =
          dirname: content: extension:
          lib.mapAttrs' (
            name: subitem: lib.nameValuePair "${prefix}/${dirname}/${name}${extension}" (linkOrCreate subitem)
          ) content;

        linkOrBuildNamedDirectory =
          dirname: content: extension:
          if isPathLikeContent content then
            {
              "${prefix}/${dirname}" = {
                source = content;
                recursive = true;
              };
            }
          else if builtins.isAttrs content then
            buildNamedDirectory dirname content extension
          else
            { };
      in
      linkOrBuildNamedDirectory "extensions" cfg.extensions ".ts"
      // linkOrBuildNamedDirectory "skills" cfg.skills ".md";
  };
}
