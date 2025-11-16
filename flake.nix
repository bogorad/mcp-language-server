{
  description = "MCP Language Server";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.mcp-language-server = pkgs.buildGoModule rec {
          pname = "mcp-language-server";
          version = "0.0.2";
          src = ./.;
          vendorHash = "sha256-WcYKtM8r9xALx68VvgRabMPq8XnubhTj6NAdtmaPa+g=";
          doCheck = false;
          subPackages = [ "." ];
          meta = with pkgs.lib; {
            description = "MCP server exposing LSP tools";
            homepage = "https://github.com/isaacphi/mcp-language-server";
            license = licenses.bsd3;
            maintainers = [ ];
          };
        };
        packages.default = self.packages.${system}.mcp-language-server;
        apps.mcp-language-server = {
          type = "app";
          program = "${self.packages.${system}.mcp-language-server}/bin/mcp-language-server";
        };
        defaultApp = self.apps.${system}.mcp-language-server;
      }
    );
}
