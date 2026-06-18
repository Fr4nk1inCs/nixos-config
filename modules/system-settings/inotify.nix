{
  flake.modules.nixos.inotify = {
    # Increase the amount of `inotify` watchers
    # Note that `inotify` watches consume 1kB on 64-bit machines.
    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default: 8192
      "fs.inotify.max_user_instances" = 1024; # default: 128
      "fs.inotify.max_queued_events" = 1048576; # default: 16384
    };
  };
}
