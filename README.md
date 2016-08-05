# CloudFlare API Client

This is a CloudFlare API Client, currently used for purging caches and updating
DNS records.

## Basic Usage

Set environment variables of :

- CLOUD_FLARE_API_KEY
- CLOUD_FLARE_EMAIL

`./bin/update_dns example.com arecord`

Compile Container:

`docker build -t cloudflare:latest .`

### Update DNS

This commands runs a program that checks current machine IP address and
CloudFlare defined ip address every 2 seconds. If both does not match, it updates the
CloudFlare *A* record with the current IP.

In order to update the IP address of `test.example.com`

```
 docker run --rm \
  -e "CLOUD_FLARE_API_KEY=<API KEY COMES HERE>" \
  -e "CLOUD_FLARE_EMAIL=<EMAIL COMES HERE>" \
  --name cloudflare \
  cloudflare:latest \
  bin/update_dns example.com test
```

### Purge Cache

Purge caches programmatically.

```
docker run --rm \
 -e "CLOUD_FLARE_API_KEY=<API KEY COMES HERE>" \
 -e "CLOUD_FLARE_EMAIL=<EMAIL COMES HERE>" \
 --name cloudflare \
 cloudflare:latest \
 bin/purge_cache example.com
```

## Systemd Service File for DNS Updates

In order to create a dynamic DNS using CloudFlare DNS services use the systemd service below.

/etc/systemd/system/docker-dns.service

```ini
[Unit]
Description=Docker Application Service
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -e "CLOUD_FLARE_API_KEY=<API KEY>" -e "CLOUD_FLARE_EMAIL=<EMAIL>" --name cloudflare cloudflare:latest bin/update_dns example.com test
ExecStop=/usr/bin/docker stop -t 2 cloudflare
ExecStopPost=/usr/bin/docker rm -f cloudflare

[Install]
WantedBy=default.target
```
