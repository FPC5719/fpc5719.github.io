{
  description = "A Nix-flake-based Haskell development environment";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
  };

  outputs = { self , nixpkgs ,... }:
  let
    # system should match the system you are running on
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [
        ghc
        cabal-install
        haskellPackages.hasktags
      ];

      shellHook = ''
        echo "Enter Haskell Environment"
        ghc --version
        exec fish
      '';
    };

    packages."${system}".default = pkgs.haskellPackages.developPackage {
      root = ./.;
      modifier = drv:
        pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
          [ cabal-install
            ghcid
            hasktags
          ]);
    };
  };
}
