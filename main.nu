def main [] {
  cd /etc/nixos
  sudo nix flake update
  let changes = (nix profile diff-closures --profile /nix/var/nix/profiles/system | split row "\n\n" | last 1 | get 0)
  sudo git commit -am 'update flake inputs' -m $changes
  sudo git push
  sudo nixos-rebuild switch
  nix profile diff-closures --profile /nix/var/nix/profiles/system | split row "\n\n" | last 1 | get 0
  cd -
  print $changes
}
