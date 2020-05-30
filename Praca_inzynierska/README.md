# Application for cryptocurrency wallets management

Author: Sławomir Górawski

Bachelor of Enginnering Thesis

Advisor: dr Leszek Grocholski

## Installation

Contents of this section are copied from the paper.

First the library must be installed for local use,
and after it the application itself.

    $ pip install -e lib[dev]
    $ pip install -e app[dev]

After installation supporting services should be set up in the background,
this can be done with `docker-compose`, i.e.:

    $ docker-compose up -d

At this point there should be a blank database available for connecting,
which needs to be populated with required tables etc.:

    $ flask db upgrade -d app/migrations

What is left is to spin up a web server,
the development one bundled with Flask will do
(specify port using the flag, default is 5000):

    $ flask run --port 5000

The application can be accessed from any web browser now.

## Testing

To run the library's unit tests, type in:

    $ pytest

For manual testing of the application there are two helper scripts.

1. `topup.py` - use to transfer funds to given address.
2. `mineblocks.py` - use to mine a Bitcoin block,
 which will confirm transactions
 and provide money for the root account
 (no need for that in Ethereum).

It may be convenient to enable automatic mining of Bitcoin blocks e.g. every second.
Unix tool `watch` can be used for this, i.e.:

    $ watch -n1 python mineblocks.py 1
