# DDNS
Update ip to github on R6300V2 with merlin firmware.
### PEM
Export the certificate of https://github.com with base64 encoding as github.cer, then run
```sh
openssl x509 -in github.cer -out github.pem
```
### Http code
The '-o' option does not work on my R6300V2 which means I can not redirect the json response to '/dev/null', so I need to split the output of curl to get the http code.
