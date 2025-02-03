let
  users = {
    fr4nk1in = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJS2YtTqHmRishJaLDp1cKKrzM9PjxG/ZLKCCU7g5pkz fushen@mail.ustc.edu.cn";
  };
  allUsers = builtins.attrValues users;

  systems = {
    darwin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNPhGQ0q6Sxuitk0KiqgDtEebhdsy2l92a2OiAiJiWd Fr4nk1in's MacBook Air";
  };
  allSystems = builtins.attrValues systems;
in {
  "deepseek-apikey.age".publicKeys = allUsers ++ allSystems;
  "fr4nk1in-ed25519.age".publicKeys = [users.fr4nk1in] ++ allSystems;
}
