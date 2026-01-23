# nixosApifox
一份nixos的apifox的配置文件，通过flake引用安装apifox
{
  description = "NixOS configuration with Apifox (Official Standard)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    apifox-github.url = "github:luozenan/nixosApifox";
    apifox-github.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, apifox-github, ... }: let
    system = "x86_64-linux";
    # 初始化pkgs，开启闭源软件支持
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; 
    };
    apifox = apifox-github.packages.${system}.apifox;
  in {
    # 系统配置
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix # 你的原有系统配置
        {
          # 添加apifox到系统环境
          environment.systemPackages = [ apifox ];
        }
      ];
    };
  };
  
  
}

或者
environment.systemPackages = [
     inputs.apifox-github.packages.${pkgs.stdenv.hostPlatform.system}.apifox
 ]
