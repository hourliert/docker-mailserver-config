# docker-mailserver-config
Creates [`docker-mailserver`](https://github.com/tomav/docker-mailserver) users and DKIM keys.

## Getting started
In your docker-compose file:

```yaml
version: '2'
services:
  mailserver-config:
    image: hourliert/docker-mailserver-config:latest
    volumes:
      - mailconfig:/tmp/docker-mailserver
    environment:
      - MAIL_USERS=user1@domain.tld;user2@domain.tld
      - MAIL_PASSWORDS=passUser1;passUser2
      - MAIL_DOMAIN=domain.tld

volumes:
  mailconfig:

```

You could then mount the `mailconfig` volume to `/tmp/docker-mailserver` in the container running `docker-mailserver`.
This volume will contain postfix_accounts.cf and openDKIM.

To see the public DKIM key, juste run `docker-compose logs`.