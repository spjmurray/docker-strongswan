# Couchbase strongSwan IPSEC VPN Container

To facilitate cross-datacenter relplication of your Couchbase buckets we add a requirement that a site-to-site VPN must connect the two sites.  The reason is that the cluster operates in an overlay network with RFC1918 addresses, these are encoded into the cluster map thus a cluster in site A must have L3 coonectivity to these addresses in site B.

This is a pure L3 routed solution, and daemon set containers must be installed on the Couchbase nodes which add a static route for the remote prefix or prefixes whose next hop is the VPN gateway.  While we could just use SNAT within the VPN gateway to mitigate the requirement for static routes, we avoid this as it would add state to the system, and connection tracking tables are only a finite size.  Therefore we sacrifice simplicity for reliability in that connections won't randomly get dropped.

## Building

    make

## Configuration

<dl>
  <dt>STRONGSWAN_LEFTID</dt>
  <dd>The local gateway's identity</dd>

  <dt>STRONGSWAN_LEFTSUBNET</dt>
  <dd>The local gateway's subnet(s) e.g. 10.0.0.0/16</dd>

  <dt>STRONGSWAN_RIGHT</dt>
  <dd>The remote gateway's public IP address</dd>

  <dt>STRONGSWAN_RIGHTID</dt>
  <dd>The remote gateway's identity</dd>

  <dt>STRONGSWAN_RIGHTSUBNET</dt>
  <dd>The remote gateways subnet(s) e.g. 10.10.0.0/16,10.16.0.0/24</dd>

  <dt>STRONGSWAN_PSK</dt>
  <dd>The pre-shared key to authenticate with</dd>
</dl>

## Running

    docker run \
      -p 500:500/udp \
      -p 4500:4500/udp \
      -e STRONGSWAN_LEFTID=aws-us-west \
      -e STRONGSWAN_LEFTSUBNET=10.0.0.0/16 \
      -e STRONGSWAN_RIGHT=85.254.56.102 \
      -e STRONGSWAN_RIGHTID=aws-us-east \
      -e STRONGSWAN_RIGHTSUBNET=10.1.0.0/16 \
      -e STRONGSWAN_PSK=supersecret \
      --cap-add NET_ADMIN \
      couchbase/strongswan:1.0.0
