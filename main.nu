# NUS: NixOS Update Script
# It's a simple script that updates your flake-based system and pushes changes to git.
# Additionally it displays which packages changed.
def main [
  --path (-p): string = '/etc/nixos'
] {
  if not ($path | path exists) {
    print 'Path does not exist'
    return
  }
  cd $path
  nix flake update
  print ''
  nixos-rebuild switch
  print ''
  let generations = (
    nix-env
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
  git commit -am 'update flake inputs' -m $changes
  print ''
  git push
}
