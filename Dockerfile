# We can use a multi-stage build to reduce our image size
# Stage 1 - Builder
FROM ubuntu:latest as builder

RUN apt-get update && apt-get install -y gcc libc6

WORKDIR /app

COPY helloworld.c .

RUN gcc -o helloworld helloworld.c

# Get the compiled output to another image. /etc/passwd will already exsist from base img
FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends libc6 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/helloworld /helloworld

ENTRYPOINT [ "/helloworld"]
# ENTRYPOINT ["/bin/sh", "-c", "/helloworld && dpkg --list | grep libc6 && cat /etc/passwd && ls -ld /tmp"] # use this to check for packages, /etc/passwd and /tmp 





