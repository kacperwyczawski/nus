def main [] {
  cd /etc/nixos
  sudo nix flake update
  sudo git commit -am 'update flake inputs'
  sudo git push
  sudo nixos-rebuild switch
  nix profile diff-closures --profile /nix/var/nix/profiles/system | split row "\n\n" | reverse | get 1
  cd -
}
