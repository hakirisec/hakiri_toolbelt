# Hakiri

Hakiri is a command line interface for the Hakiri platform. It allows Ruby on Rails developers to automate version scraping of servers, databases and other technologies that they use in their stacks. It also shows CVE vulnerabilities found in their system software versions.

### Installation

Hakiri CLI is a Ruby gem that can be installed by

~~~ sh
gem install hakiri
~~~

After it's installed, restart your command line and you should be good to go.

### Test Your System in 5 Seconds

### Authentication Token

This gem doesn't require you to sign up for a Hakiri account if you are using basic functionality. For some other things that require connection to Hakiri API you'll have to get an authentication token from Hakiri.

1. First of all, [sign up](https://www.hakiriup.com/sign_up) for an account on Hakiri.

2. Then go to [your account settings](https://www.hakiriup.com/account) and copy an authentication token.

3. Lastly setup your authentication token (`HAKIRI_AUTH_TOKEN`) as an environmental variable in your shell:

    ~~~ sh
    $ echo 'export HAKIRI_AUTH_TOKEN="your auth token"' >> ~/.bash_profile
    ~~~

    **Ubuntu note**: Modify your `~/.profile` instead of `~/.bash_profile`.

    **Zsh note**: Modify your `~/.zshrc` file instead of `~/.bash_profile`.

### Getting Started

#### System Scan

You can scan your system for vulnerabilities. Supply a JSON file with technologies that you are interested in and run this command.

~~~ sh
$ hakiri system:scan -s my_stack.json
~~~

#### Step by Step

TBD

#### Sync Stack

TBD

### Contribute

- Fork the project.
- Write code for a feature or bug fix.
- Commit, do not make changes to version.
- Submit a pull request.

### License

(The MIT license)

Copyright (c) 2013 Vasily Vasinov

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.