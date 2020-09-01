# Rinetd with multiple port-bindings

Rinetd is a single-process server which handles any number of connections to the address/port pairs. This Docker image was based on Ubuntu and pre-installed with rinetd that allows defining multiple port-bindings using a space-delimited environment variable.

To define multiple port-bindings, `docker run` this image by passing the environment variable `DESTINATIONS` using the following format:

```
<destip1>:<destport1>:<localport1> <destip2>:<destport2>:<localport2> <destip3>:<destport3> 
```

Example:

```
192.168.0.1:80:8080 mail.google.com:443:8443 www.google.com:443
```

Separate multiple destinations using space characters. You can omit the local port, in which case, local port will be the same as the destination port.

In addition, you can also enable log file by passing the log file path as environment variable `LOGFILE`. Rinetd also supports outputting web-server style logfile format, which can be enabled by passing a non-empty environment variable `LOGCOMMON`.