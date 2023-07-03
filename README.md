
# PiVPN Web (OpenVPN)

PiVPN Web is a service that allows you to manage users for PiVPN. With this service, you can create, remove, enable, disable users, as well as download or copy the configuration file for your PiVPN setup.

![Screenshot](https://github.com/g8998/pivpn-web/assets/135697447/0fd20246-ffe4-4bc6-957d-4e7e73aa599e)

## Functions

PiVPN Web provides the following functions:

- Log in with the user you have installed PiVPN with.
- Create a new user: Create a new user for your PiVPN setup.
- Enable user: Enable an existing user to allow VPN access.
- Disable user: Disable an existing user to revoke VPN access.
- Delete user: Remove an existing user from your PiVPN setup.
- Download configuration file: Download the configuration file for a specific user.
- Copy configuration: Copy the configuration file for a specific user to the clipboard.
- View connected clients: See the remote ip, virtual ip, bytes received and sent, and the time connected.
- The web interface of PiVPN Web is designed to be responsive

## Requirements

- Any of this tested OS (Raspbian OS, Debian, Ubuntu)
- PiVPN installed and configured (OpenVPN)
- Apache2 installed
- PHP installed

## Installation

To install PiVPN Web, follow these steps:

1.  Install PiVPN (OpenVPN)

```bash
curl -L https://install.pivpn.io | bash
```
2.  Install Apache2 and PHP

```bash
sudo apt-get update && sudo apt-get install apache2 php git
```
3.  Edit de file `/etc/apache2/apache2.conf`  and change the default user and group to your user and group.

```bash
User "your-username"
Group "your-group"
```
4. Restart apache: `sudo service apache2 restart`
5. Move to the apache directory: `cd /var/www/html/`
6. Clone the repository: `git clone https://github.com/g8998/pivpn-web.git`
7. Change permissions of the folder:
```bash
sudo chown -R "your-username" pivpn-web/
sudo chgrp -R "your-username" pivpn-web/
```
8. If your user need the password for sudo commands create the file:
`/etc/sudoers.d/"your-username"` with this content:
```bash
"your-username" ALL=(ALL) NOPASSWD:/bin/cat,/bin/sed, /opt/pivpn/openvpn/*
```

## Usage

To use PiVPN Web, follow these steps:

1. Open your web browser and navigate to `http://localhost/pivpn-web/` (or the appropriate IP address if running remotely).
2. Sign in with your user's credentials.

That's it! You can now manage your PiVPN users easily with PiVPN Web. Enjoy!
