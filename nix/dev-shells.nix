{ inputs, ... }:
let
  agenix_secret_path = "/home/mar/.cache/agenix-shell/secrets";
in
{
  agenix-shell = {
    secretsPath = agenix_secret_path;
    secrets = {
      TAILSCALE_CLIENT_ID.file = ../secret/TAILSCALE_CLIENT_ID;
      TAILSCALE_CLIENT_SECRET.file = ../secret/TAILSCALE_CLIENT_SECRET;
      DIGITAL_OCEAN_TOKEN.file = ../secret/DIGITAL_OCEAN_TOKEN;
      DIGITAL_OCEAN_TOKEN_SPEC.file = ../secret/DIGITAL_OCEAN_TOKEN_SPEC;
    };
  };
  perSystem = { config, pkgs, self', lib, ... }: {
    config = {

      devenv.shells.default = {
        packages =
          let
            treefmt = [ config.treefmt.build.wrapper ];
            kubernetesPackages = with pkgs; [ minikube k3d argocd kubernetes-helm kubectl k9s self'.packages.yoke ];
            agenix = [ inputs.agenix.packages.x86_64-linux.default ];
          in
          treefmt ++ kubernetesPackages ++ agenix;

        enterShell = ''
          source ${lib.getExe config.agenix-shell.installationScript}
          ${pkgs.k3d}/bin/k3d cluster list | grep -q "main" || ${pkgs.k3d}/bin/k3d cluster create main -p "80:80@loadbalancer"
          export KUBECONFIG="$(k3d kubeconfig write main)"
        '';

        processes = {
          # kubernetes = {
          #   exec = ''
          #     "${pkgs.minikube}/bin/minikube" status || "${pkgs.minikube}/bin/minikube" start
          #     "${pkgs.minikube}/bin/minikube" tunnel --bind-address='*' -c
          #   '';
          # };
          argocd = {
            exec = ''
              "${pkgs.kubectl}/bin/kubectl" get namespace argocd || "${pkgs.kubectl}/bin/kubectl" create namespace argocd
              #check if argocd is already installed
              "${pkgs.kubectl}/bin/kubectl" get deployment argocd-server -n argocd || "${pkgs.kubectl}/bin/kubectl" apply -n argocd -f ${inputs.argocd}

              helm repo add tailscale https://pkgs.tailscale.com/helmcharts
              helm repo update

              helm upgrade \
              --install \
              tailscale-operator \
              tailscale/tailscale-operator \
              --namespace=tailscale \
              --create-namespace \
              --set-string oauth.clientId="$(cat ${agenix_secret_path}/TAILSCALE_CLIENT_ID)" \
              --set-string oauth.clientSecret="$(cat ${agenix_secret_path}/TAILSCALE_CLIENT_SECRET)" \
              --wait

            '';
          };
        };

        git-hooks = {
          hooks.nixpkgs-fmt.enable = true;
          hooks.deadnix.enable = true;
          hooks.nil.enable = true;
          hooks.statix.enable = true;
          hooks.typos.enable = true;
          hooks.commitizen.enable = true;
          hooks.yamlfmt.enable = true;
          hooks.statix.settings.format = "stderr";
          hooks.statix.args = [ "--config" "${pkgs.writeText "conf.toml" "disabled = [ repeated_keys ]"}" ];
          hooks.typos.settings.ignored-words = [ "noice" ];
          hooks.typos.stages = [ "manual" ];
        };
      };

      treefmt.config = {
        programs.nixpkgs-fmt.enable = true;
        programs.yamlfmt.enable = true;
      };
    };
  };
}
