FROM alpine:3.7

# Install strongSwan, this will pull in iproute2 needed by the starter script
RUN apk add --no-cache curl strongswan

# Copy over the IPSEC configuration templates
COPY ipsec.conf ipsec.secrets /etc/

# Copy the starter script over
COPY starter /usr/local/bin/

# Expose the IKE and IKE-NAT ports
EXPOSE 500/tcp 500/udp 4500/udp

# Call the starter script which will configure and start the IKE service
CMD /usr/local/bin/starter
