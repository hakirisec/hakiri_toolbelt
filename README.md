# Hakiri
Hakiri is a command line interface for the Hakiri platform. It allows Ruby on Rails developers to collect versions of servers, databases and other technologies that they use in their stacks. It also shows CVE vulnerabilities found in their system software versions.

## Installation
```
gem install hakiri
```

## Authentication Token
For some extra functionality, you'll have to get an authentication token from Hakiri.

TBD

## Getting Started
### System Scan
You can scan your system for vulnerabilities. Supply a JSON file with technologies that you are interested in and run this command.
```
$ hakiri system:scan -s my_stack.json
```

### Step by Step
TBD

### Sync Stack
TBD

## Contribute
- Fork the project.
- Write code for a feature or bug fix.
- Commit, do not make changes to version.
- Submit a pull request.