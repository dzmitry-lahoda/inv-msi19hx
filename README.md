# Readme

My local and remote nix configs.

## Git signing with TPM2

`home.nix` configures Git commit signing through TPM2-enabled GnuPG and
gpg-agent, using the existing OpenPGP key. Apply it with:

```sh
home-manager switch --flake .
```

On the physical machine, ensure `/dev/tpmrm0` exists and your user has read/write
access (usually through the host's `tss` group). Home Manager does not configure
host device permissions.

The signing key must also be converted once. Before conversion, keep a secure
offline backup of the secret key: the converted key is bound to this TPM and
cannot be converted back. Keep the resulting TPM-bound key file as well.

```sh
gpg --list-secret-keys --keyid-format long --with-subkey-fingerprint B6DAD565C19E1C302B735664BF77F46FF7501BE1
gpg --edit-key B6DAD565C19E1C302B735664BF77F46FF7501BE1
```

In the edit prompt, select the signing subkey with `key N` (replace `N` with its
listed index), then run `keytotpm` and `save`. If the primary key is the signing
key, leave subkeys unselected. If there are several signing keys, set
`programs.git.settings.user.signingkey` to the converted key's full fingerprint
followed by `!` so Git selects that exact key. TPM2 guarantees support for
RSA2048 and NIST P-256; other algorithms depend on the hardware.

Verify signing in a repository with `git commit --allow-empty -S -m "Test TPM2 signing"`
and `git log -1 --show-signature`.

See [GnuPG key management](https://gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html)
for `keytotpm` details.
