{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      services = {
        openssh = {
          enable = true;
          ports = [2222];

          settings = {
            PasswordAuthentication = true;
            PermitRootLogin = "no";
          };

          extraConfig = ''
            PubkeyAuthentication yes
            KbdInteractiveAuthentication yes
          '';
        };

        fail2ban = {
          enable = true;
          bantime-increment.enable = true;
        };
      };

      # SSH login notification - USER systemd service
      systemd.user.services.ssh-login-notifier = {
        description = "SSH Login Notification Service";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];

        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash /etc/ssh/monitor-logins.sh";
          Restart = "always";
          RestartSec = "10s";
          Type = "simple";
        };
      };

      # Script to monitor SSH logins (user-readable location)
      environment = {
        systemPackages = with pkgs; [openssl];

        etc."ssh/monitor-logins.sh" = {
          text = ''
            #!${pkgs.bash}/bin/bash
            # Monitor SSH logins via journalctl and send notifications

            # Use user home directory for logs (no root permissions needed)
            LOG_FILE="$HOME/.local/share/ssh-logins.log"
            NOTIFY_CMD="${pkgs.libnotify}/bin/notify-send"

            # Ensure log directory and file exist
            mkdir -p "$HOME/.local/share"
            touch "$LOG_FILE"

            # Monitor SSH journal for successful logins
            ${pkgs.systemd}/bin/journalctl -u sshd -f -n 0 | while read -r line; do
              # Check for successful publickey authentication
              if echo "$line" | grep -q "Accepted.*for.*from"; then
                # Extract information
                USER=$(echo "$line" | grep -oP 'for \K\w+' | head -1)
                IP=$(echo "$line" | grep -oP 'from \K[0-9.]+' | head -1)
                PORT=$(echo "$line" | grep -oP 'port \K[0-9]+' | head -1)
                TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

                # Skip if no user found (shouldn't happen)
                [[ -z "$USER" ]] && continue

                # Determine IP (handle IPv6)
                if [[ -z "$IP" ]]; then
                  IP=$(echo "$line" | grep -oP 'from \K[0-9a-f:]+' | head -1)
                fi

                # Log the login
                {
                  echo "=== SSH Successful Login ==="
                  echo "Timestamp: $TIMESTAMP"
                  echo "User: $USER"
                  echo "Remote IP: $IP"
                  echo "Remote Port: $PORT"
                  echo "Log Line: $line"
                  echo ""
                } >> "$LOG_FILE"

                # Send desktop notification (now running as user, so this works!)
                "$NOTIFY_CMD" -i dialog-information -u normal "SSH Login" "User $USER logged in from $IP" 2>/dev/null || true
              fi

              # Check for failed authentication attempts
              if echo "$line" | grep -q "Failed.*for.*from"; then
                USER=$(echo "$line" | grep -oP 'for \K\w+' | head -1)
                IP=$(echo "$line" | grep -oP 'from \K[0-9.]+' | head -1)
                TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

                if [[ -n "$USER" ]] && [[ -n "$IP" ]]; then
                  {
                    echo "=== SSH Failed Login Attempt ==="
                    echo "Timestamp: $TIMESTAMP"
                    echo "User: $USER"
                    echo "Remote IP: $IP"
                    echo "Log Line: $line"
                    echo ""
                  } >> "$LOG_FILE"
                fi
              fi
            done
          '';
          mode = "0755";
        };
      };

      hm = {
        programs = {
          ssh = {
            enable = true;
            enableDefaultConfig = false;

            matchBlocks = {
              "github.com" = {
                user = "angeldust";
                identityFile = "~/.ssh/id_ed25519";
              };

              "*" = {
                forwardAgent = false;
                serverAliveInterval = 0;
                serverAliveCountMax = 3;
                compression = false;
                addKeysToAgent = "no";
                hashKnownHosts = false;
                userKnownHostsFile = "~/.ssh/known_hosts";
                controlMaster = "no";
                controlPath = "~/.ssh/master-%r@%n:%p";
                controlPersist = "no";
              };
            };
          };

          gpg = {
            enable = true;
          };
        };

        services = {
          gpg-agent = {
            enable = true;
            enableSshSupport = true;
          };
          ssh-agent = {
            enable = true;
            enableFishIntegration = true;
          };
        };
      };
    };
  };
}
