# bash_fail-to-wait

> :information_source: This is fixed in [Bash-5.1 patch 10][2].

Small repository used to reproduce a potential bug with the `wait` command in
Bash >=5.1.0

## The Problem
The `wait` command cannot be called again after it has been interrupted by a
system signal (e.g. SIGHUP), and exits with code 127.

This is not the case in Bash 5.0.x, so I would say this is a regression of some
sort.

## What Is Happening
In the `fail_to_wait.sh` I create a `trap` for SIGHUP which only prints that
a signal of this type has been received. Sending in such a signal will cause the
`wait` at the bottom to return (this is expected), but since we still want to
wait for our child process we loop and wait again in the case that the exit code
was 128+SIGHUP=129.

In Bash 5.0.3 this works as expected, and the script will return to waiting for
the child process to exit. However, in Bash 5.1.0 we get an error from `wait`
and it exits with code 127 the second time we try to wait for the child process.

> My real world usage of this feature can be found [here][1].

## How to Reproduce
To make it simple to reproduce I have created a Docker image and a Makefile
that have all the necessary commands listed. Do it in the following order
to reproduce:

```bash
make build

make run50
```

and from another terminal you can send in a SIGHUP via the following command:

```bash
make send-sighup
```

Since we are running Bash 5.0 this should not produce an error. Close the
container by giving it `Ctrl+C`, and then starting the same script again but
using Bash 5.1 this time:

```bash
make run51
```

Sending in the signal this time should terminate the container with exit
code 127.





[1]: https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/src/scripts/start_nginx_certbot.sh#L97
[2]: https://git.savannah.gnu.org/cgit/bash.git/commit/?id=910fcdc415abeb3d7d85fb46ee0d3e804a4c47a6
