{
  description = "System Configuration";

  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = inputs @ { self, nixpkgs, home-manager, ... }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system; 
	      config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in { 
      nixosConfigurations = { 
        laptop = lib.nixosSystem { 
	          
          inherit system;
	        
          modules = [ 
            ./configuration.nix 

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.greglaurent = { 
                home.stateVersion = "22.05";
		            home.packages = with pkgs; [ 
                  htop 
                  vscode
		            ]; 
                imports = [ ./home.nix ];
              };

              users.users.greglaurent = { 
		            isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" ];
              };
            }
          ];
	      };
      };
    };
}
