# hooks.d plugin for dehydrated.io


https://dehydrated.io is a great simple [ACME client](https://letsencrypt.org/docs/client-options/).

It has a `conf.d` directory so that packages can coordinate installing plugins,
but [doesn't want to provide a similar `hooks.d`](https://github.com/dehydrated-io/dehydrated/issues/270) directory
so that they can coordinate installing hooks, which are scripts that react to actions taken by `dehydrated`.

This provides that feature 🌉.

## Installation

### From source

```
git clone https://github.com/kousu/dehydrated-hooks
cd dehydrated-hooks
install -o root -g root conf.d/hooks.sh /etc/dehydrated/conf.d # or wherever your dehydrated's ${CONF_D} is pointed.
install -o root -g root hooks.sh /var/lib/dehydrated/hooks/    # or wherever your dehydrated's ${BASEDIR}/hooks/ is.
```

### From package

#### Debian/Ubuntu

TODO

#### ArchLinux

TODO

## Usage

There are three hooks `dehydrated` will run, and each has a separate directory of hooks:

* `deploy-challenge` in `"${BASEDIR}"/hooks/deploy-challenge.d/`, run after receiving the challenge from the CA with arguments `altname token-filename token-content`.
* `clean-challenge` in `"${BASEDIR}"/hooks/clean-challenge.d/`, run (???) with arguments `"" token-filename token-content`
* `deploy-cert`, in `"${BASEDIR}"/hooks/deploy-cert.d/`, run after receiving a newly signed cert from the CA, with arguments `domain path/to/privkey.pem path/to/cert.pem path/to/fullchain.pem`

Put scripts or other programs in these directories as necessary, make sure to `chmod +x` them, and they will be invoked the next time you run `dehydrated -c`.

You can control the order the hooks run in by naming them -- so a hook that should run before everything should start '00-',
and one that should run after everything should be 'zz-'. But ideally you won't need to use that very much.


### Testing

To test your hooks non-destructively...

TODO

## Examples

Once installed, here are some things you can do with this:

### Keeping certs under `/etc/ssl/`

```
#!/bin/sh
# /var/lib/dehydrated/hooks/deploy-cert.d/00-install
# install certificates from dehydrated into /etc/
# certs form part of system config, so they belong under /etc, though the *originals* live under /var/
# Another solution would be to set CERTDIR=/etc/dehydrated/certs/ but that's sort of weird too.

domain="$1"
privkey="$2"
cert="$3"
fullchain="$4"

cp "$fullchain" /etc/ssl/certs/"$domain".pem
cp "$privkey" /etc/ssl/private/"$domain".key
```

```
#!/bin/sh
# /var/lib/dehydrated/hooks/deploy-cert.d/01-etckeeper
# meant to be used with 00-install
domain="$1"
etckeeper commit "Renew cert for $domain."
```

### Make all your daemons pick up the new certificates

```
#!/bin/sh
# /var/lib/dehydrated/hooks/deploy-cert.d/nginx
systemctl reload nginx
```

```
#!/bin/sh
# /var/lib/dehydrated/hooks/deploy-cert.d/prosody
prosodyctl reload
```

```
#!/bin/sh
# /var/lib/dehydrated/hooks/deploy-cert.d/rsyslogd
systemctl reload rsyslogd
```

You could put all of these into one line, but then your services become interdependent and that makes them more fragile: if you to replace nginx with apache you need to remember to take it out of your hook script; this way, you just `rm /var/lib/dehydrated/hooks/deploy-cert.d/nginx` and replace it with a `/var/lib/dehydrated/hooks/deploy-cert.d/apache`.

### Use a specific DNS-01 for different subdomains

TODO