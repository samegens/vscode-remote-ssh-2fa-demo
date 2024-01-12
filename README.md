# 2FA VM

This is a VM that uses 2FA to login. I used this VM to test if vscode properly supports 2FA
when using remote SSH.

## Requirements

- [VirtualBox](https://www.virtualbox.org/) (I used version 6.1.38)
- [Vagrant](https://www.vagrantup.com/) (I used version 2.4.0)

## Instructions

1. ```vagrant up```
2. ```vagrant ssh```
3. ```google-authenticator```, answer y to all questions, scan QR code with FreeOTP.
4. Log out of VM (Ctrl-D)
5. Test the setup by doing ```ssh 192.168.13.49```, this will ask for both a password and a TOTP verification

To configure vscode to make a remote connection to this VM:

1. In vscode install the extension [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh).
2. F1 -> 'Remote-SSH: Open SSH Configuration File...' -> select the config file in .ssh in your home directory.
3. Add

       Host 192.168.13.49
           HostName 192.168.13.49
           User vagrant
           ForwardAgent yes
           ControlMaster auto
           ControlPath ~/.ssh/socket_%r@%h-%p
           ControlPersist 600

   and save the configuration.

4. F1 -> 'Remote-SSH: Connect to Host...' -> select 192.168.13.49.
   This will open a new vscode window.
5. Enter the password ('vagrant').
6. Open FreeOTP, select the newly added account and enter the displayed
   verification code in vscode.
7. Vscode will now install some stuff.
   When it's ready, you'll have a remote session.
   You can open a folder on the remote
   server and then develop like you would locally.
   When you open a terminal it will open a shell on the remote server.

## Vscode

When trying to use vscode with this VM I had some issues: it kept asking for password and verification.
Appearantly this is a [known issue with a workaround](https://github.com/microsoft/vscode-remote-release/issues/2518).
My own workaround is to use [SSH connection pooling](https://www.cyberciti.biz/faq/linux-unix-reuse-openssh-connection/).
Because the initial SSH connection is reused by following connections, the password and verification code
are only requested once.

To use SSH connection pooling for this VM I configure SSH in ~/.ssh/config like this:

    Host 192.168.13.49
        HostName 192.168.13.49
        User vagrant
        ForwardAgent yes
        ControlMaster auto
        ControlPath ~/.ssh/socket_%r@%h-%p
        ControlPersist 600

## TODO

I couldn't get this to work with using both a private key and 2FA. For some reason the TOTP challenge was skipped
when I used a private key. Figuring out why was not interesting for me so I just use a password now.
