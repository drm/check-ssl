# check-ssl.sh

Straight-forward utility on top of OpenSSL to verify an existing SSL
configuration.

Dependencies: `openssl` and `dig` command line utilities.

## Examples

```bash
$ ./check-ssl.sh example.org
example.org @ 93.184.216.34
Hostname example.org OK
notAfter=Feb 13 23:59:59 2024 GMT
Certificate will not expire
```

```bash
$ ./check-ssl.sh example.org google.com
Verification error: hostname mismatch
Verify return code: 62 (hostname mismatch)
notAfter=Sep 11 08:16:08 2023 GMT
Certificate will not expire
```

```bash
$ ./check-ssl.sh expired.badssl.com
expired.badssl.com @ 104.154.89.105
Hostname expired.badssl.com OK
notAfter=Apr 12 23:59:59 2015 GMT
Certificate will expire
```

## Color output by default

The output 'will expire' and 'mismatch' will be colored by explicitly colored
grepping, which is a convencience feature. You can disable that by overriding
the `GREP_FLAGS` which is set to `--color` by default.

```bash
$ GREP_FLAGS="" ./check-ssl.sh expired.badssl.com
expired.badssl.com @ 104.154.89.105
Hostname expired.badssl.com OK
notAfter=Apr 12 23:59:59 2015 GMT
Certificate will expire
```

(`will expire` will not be highlighted in this case)

## More info

Read the source code. It has a fraction of the lines of this readme ;)

## License

(c) Copyright 2023, Gerard van Helden

[DBAD](https://dbad-license.org/)


