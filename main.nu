# NUS: NixOS Update Script
# It's a simple script that updates your flake-based system and pushes changes to git.
# Additionally it displays which packages changed.
def main [] {
  cd /etc/nixos
  sudo nix flake update
  print ''
  sudo nixos-rebuild switch
  print ''
  let generations = (
    sudo nix-env
      --list-generations
      --profile /nix/var/nix/profiles/system
    | lines
    | last 2
    | each {|| split column '   '
    | get column1
    | str trim
    | get 0 }
  )
  let changes = (
    nvd diff
      $'/nix/var/nix/profiles/system-($generations.0)-link'
      $'/nix/var/nix/profiles/system-($generations.1)-link'
  )
  print $changes
  print ''
  sudo git commit -am 'update flake inputs' -m $changes
  print ''
  sudo git push
  cd $env.OLDPWD
}
