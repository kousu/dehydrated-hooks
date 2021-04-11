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