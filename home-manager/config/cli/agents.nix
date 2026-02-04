_: {
  programs.opencode = {
    enable = true;
    settings = {
      plugin = [
        "oh-my-opencode"
        "opencode-antigravity-auth@1.4.3"
      ];
      provider = {
        google = {
          name = "Google";
          models = {
            antigravity-claude-opus-4-5-thinking = {
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              name = "Claude Opus 4.5 Thinking (Antigravity)";
              variants = {
                low = {thinkingConfig = {thinkingBudget = 8192;};};
                max = {thinkingConfig = {thinkingBudget = 32768;};};
              };
            };
            antigravity-claude-sonnet-4-5 = {
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              name = "Claude Sonnet 4.5 (Antigravity)";
            };
            antigravity-claude-sonnet-4-5-thinking = {
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              name = "Claude Sonnet 4.5 Thinking (Antigravity)";
              variants = {
                low = {thinkingConfig = {thinkingBudget = 8192;};};
                max = {thinkingConfig = {thinkingBudget = 32768;};};
              };
            };
            antigravity-gemini-3-flash = {
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              name = "Gemini 3 Flash (Antigravity)";
              variants = {
                high = {thinkingLevel = "high";};
                low = {thinkingLevel = "low";};
                medium = {thinkingLevel = "medium";};
                minimal = {thinkingLevel = "minimal";};
              };
            };
            antigravity-gemini-3-pro = {
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              name = "Gemini 3 Pro (Antigravity)";
              variants = {
                high = {thinkingLevel = "high";};
                low = {thinkingLevel = "low";};
              };
            };
          };
        };
      };
    };
  };

  xdg.configFile = {
    "opencode/oh-my-opencode.json".text = builtins.toJSON {
      "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
      google_auth = true;
      agents = {
        sisyphus = {
          model = "github-copilot/claude-opus-4.5";
          variant = "max";
        };
        hephaestus = {
          model = "github-copilot/gpt-5.2-codex";
          variant = "medium";
        };
        oracle = {
          model = "github-copilot/gpt-5.2";
          variant = "high";
        };
        librarian = {
          model = "github-copilot/claude-sonnet-4.5";
        };
        explore = {
          model = "github-copilot/gpt-5-mini";
        };
        multimodal-looker = {
          model = "google/gemini-3-flash";
        };
        prometheus = {
          model = "github-copilot/claude-opus-4.5";
          variant = "max";
        };
        metis = {
          model = "github-copilot/claude-opus-4.5";
          variant = "max";
        };
        momus = {
          model = "github-copilot/gpt-5.2";
          variant = "medium";
        };
        atlas = {
          model = "github-copilot/claude-sonnet-4.5";
        };
      };
      categories = {
        visual-engineering = {
          model = "google/gemini-3-pro";
        };
        ultrabrain = {
          model = "github-copilot/gpt-5.2-codex";
          variant = "xhigh";
        };
        deep = {
          model = "github-copilot/gpt-5.2-codex";
          variant = "medium";
        };
        artistry = {
          model = "google/gemini-3-pro";
          variant = "max";
        };
        quick = {
          model = "github-copilot/claude-haiku-4.5";
        };
        unspecified-low = {
          model = "github-copilot/claude-sonnet-4.5";
        };
        unspecified-high = {
          model = "github-copilot/claude-sonnet-4.5";
        };
        writing = {
          model = "google/gemini-3-flash";
        };
      };
    };
  };
}
