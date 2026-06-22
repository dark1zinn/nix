{inputs, ...}: {
  flake.nixosModules.dark1zin-omp = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.omp
    ];
  };
}
