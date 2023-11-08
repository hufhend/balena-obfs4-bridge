# Base docker image
# If you want to upgrade, add new sha from debian:stable-slim arm/v5
FROM debian:stable-slim@sha256:a9a23d94d9a4b1b01099d29642303e9e67838d2f951b289bc088d079a498b11a

LABEL maintainer="Philipp Winter <phw@torproject.org>"

# Install dependencies to add Tor's repository.
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    gpg-agent \
    ca-certificates \
    libcap2-bin \
    --no-install-recommends

# See: <https://2019.www.torproject.org/docs/debian.html.en>
RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN printf "deb https://deb.torproject.org/torproject.org bullseye main\n" >> /etc/apt/sources.list.d/tor.list

# Install remaining dependencies.
RUN apt-get update && apt-get install -y \
    tor \
    tor-geoipdb \
    obfs4proxy \
    --no-install-recommends

# Allow obfs4proxy to bind to ports < 1024.
RUN setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy

# Our torrc is generated at run-time by the script start-tor.sh.
RUN rm /etc/tor/torrc
RUN chown debian-tor:debian-tor /etc/tor
RUN chown debian-tor:debian-tor /var/log/tor

COPY get-bridge-line /usr/local/bin
RUN chmod 0755 /usr/local/bin/get-bridge-line

COPY start-tor.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/start-tor.sh

USER debian-tor

CMD [ "/usr/local/bin/start-tor.sh" ]
