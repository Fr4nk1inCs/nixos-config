let
  users = {
    darwin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJS2YtTqHmRishJaLDp1cKKrzM9PjxG/ZLKCCU7g5pkz";
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMP+Fa4Yhx/APEKYEGxpUb3Z6iPLbwhaTCTPK2w49aq2";
  };
  allUsers = builtins.attrValues users;

  systems = {
    darwin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNPhGQ0q6Sxuitk0KiqgDtEebhdsy2l92a2OiAiJiWd";
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFChdda78yatiqDYUFcPwavnE47IwtrK55taQ2VPJCm";
  };
  allSystems = builtins.attrValues systems;
in {
  "deepseek-apikey.age".publicKeys = allUsers ++ allSystems;
  "fr4nk1in-ed25519.age".publicKeys = allUsers ++ allSystems;
}
