This is a simple Ansible script to install a bunch of stuff I want on most of my systems. There's a gui and a cli tag
for the gui and cli roles, so if you are running an install on a non-GUI install just run with `-t cli`.

It assumes Ansible is installed. I usually install Ansible via [`pipx`](https://pipx.pypa.io/latest/) as that allows you
to install the latest version of Ansible and it doesn't pollute your global environment. To do that:

```bash
sudo apt install pipx
pipx install --include-deps ansible
pipx inject ansible python-debian
```

## Notes

Note: Newer versions of Debian/Ansible [deprecated
`apt-key`](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_key_module.html) so you'll see
`apt_key` calls with `state: absent` to remove the legacy keys thus avoid the `Key is stored in legacy trusted.gpg
keyring` errors), followed by `deb822_repository` calls to install keys along with the repo correctly.
