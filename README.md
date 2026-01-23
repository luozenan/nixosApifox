# nixosApifox
一份nixos的apifox的配置文件，通过flake引用安装apifox
###
inputs = {

    apifox-github = {
      url = "github:luozenan/nixos-apifox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
};
###

###
environment.systemPackages = [

     inputs.apifox-github.packages.${pkgs.stdenv.hostPlatform.system}.apifox
     
]
 ###
