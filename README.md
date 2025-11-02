**bean-docker:**

This is a project that makes it easier to run Beancount via docker, plus an integration with git/github so
that you have easy backup/version-control of your accounting data/software.

[**Beancount**](https://github.com/beancount/beancount) is a plain-text, accounting software. One of my most
favorite features of beancount is that it is (or say, can be) a tamper-proof accounting software with you
use it with git and github. Just commit your changes and push them to github. However git and github, and
even beancount are only (easily) accessible to developers. This project makes it easier for non-developers
to also reap the benefits of beancount by providing a docker image for easy installation and bundling it
with a basic git server where you can run basic git commands as well as push your changes to github for
easy backup.

If you want to create a project, here are the steps:

1. Have Docker installed in your system.
1. Clone or download this repo.
1. Copy the `.env.example` file to `.env` file and set the environment variables
   as necessary. You can find instructions on how to set github repo token [here](https://github.com/sumanchapai/gw?tab=readme-ov-file#generating-github-token).
1. Run `docker compose up` and you should have your beancount ready to use with git support at
   `localhost:8063` or whatever port you've defined in the environment file.

TODO:
Update readme later.
