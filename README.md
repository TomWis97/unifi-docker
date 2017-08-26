# Unifi Controller Docker container
An Docker container for the Ubiquiti Unifi Controller software.

## Why?
The software officially is only released for Ubuntu. But because not everyone likes to run 50 different Linux distro's in one environment I created this.

## "It's broken"
Please create an issue if that's the case. Or even better, add a pull request.

## Known issues
- Runs two processes (Unifi and Mongodb) in a single container. The Unifi software only seems to support a localhost database connection.
- Mongodb is stopped by sending it an SIGINT. Not really ideal.
- Container runs as root because the mongo init script can't handle anything different.

