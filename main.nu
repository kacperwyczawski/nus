def main [] {
  cd /etc/nixos
  sudo nix flake update
  sudo git push
  sudo nixos-rebuild switch
  let generations = sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | lines | last 2 | each {|| split column '   ' | get column1 | str trim | get 0 }
  cd -
  let changes = nvd diff $'/nix/var/nix/profiles/system-($generations.0)-link' $'/nix/var/nix/profiles/system-($generations.1)-link'
  print $changes
  sudo git commit -am 'update flake inputs' -m $changes
}
