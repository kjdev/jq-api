jq API Example
==============

Create data JSON
----------------

Create a JSON data file.

Use GitHub repository data.

``` sh
$ curl -sL -o data.json -G -d per_page=100 https://api.github.com/users/kjdev/repos
```

Create configuration JSON
-------------------------

Create configuration JSON file.

[config.json](config.json)

Build Docker image
------------------

Build a Docker image of the application.

``` sh
$ echo 'FROM ghcr.io/kjdev/jq-api' | docker build -f - -t app .
```

Command Line mode
-----------------

Set command for command line.

``` sh
$ cli() { docker run --rm app cli "${@}"; }
```
> Set volume if you do not want to create a Docker image of the application
> ```
> docker run --rm -v $PWD:/app ghcr.io/kjdev/jq-api cli "${@}";
> ```

repos:

``` sh
$ cli repos
[
  {
    "id": 4109795,
    "name": "apache-mod-sundown",
    "description": "mod_sundown is Markdown handler module for Apache HTTPD Server.",
    "language": "C",
    "license": "apache-2.0",
    "topics": []
  },
  {
    "id": 4198802,
    "name": "apache-mod-v8",
    "description": "mod_v8 is Javascript V8 Engine handler module for Apache HTTPD Server.",
    "language": "C++",
    "license": "apache-2.0",
    "topics": []
  },
  {
    "id": 4319065,
    "name": "apache-mod-mongo",
    "description": "mod_mongo is mongoDB handler module for Apache HTTPD Server.",
    "language": "C++",
    "license": "apache-2.0",
    "topics": []
  }
]
```

repos: specify limit

``` sh
$ cli repos -d limit=1
[
  {
    "id": 4109795,
    "name": "apache-mod-sundown",
    "description": "mod_sundown is Markdown handler module for Apache HTTPD Server.",
    "language": "C",
    "license": "apache-2.0",
    "topics": []
  }
]
```

repos: specify limit and since

``` sh
$ cli repos -d limit=1 -d since=4109795
[
  {
    "id": 4198802,
    "name": "apache-mod-v8",
    "description": "mod_v8 is Javascript V8 Engine handler module for Apache HTTPD Server.",
    "language": "C++",
    "license": "apache-2.0",
    "topics": []
  }
]
```

repos: specify item

``` sh
$ cli repos -d item=name
[
  "apache-mod-sundown",
  "apache-mod-v8",
  "apache-mod-mongo"
]
```

repos/{repo}:

``` sh
$ cli repos/php-ext-brotli
{
  "id": 43108981,
  "name": "php-ext-brotli",
  "description": "Brotli Extension for PHP",
  "language": "C",
  "license": "mit",
  "topics": []
}
```

repos/{repo}/{item}:

``` sh
$ cli repos/php-ext-brotli/description
"Brotli Extension for PHP"
```

repos/count:

``` sh
$ cli repos/count
65
```

repos/language:

``` sh
$ cli repos/language
{
  "C": 39,
  "C++": 6,
  "Dockerfile": 1,
  "Go": 2,
  "PHP": 13,
  "Shell": 2
}
```

repos/license:


```
$ cli repos/license
{
  "apache-2.0": 10,
  "bsd-2-clause": 1,
  "bsd-3-clause": 2,
  "isc": 2,
  "mit": 25,
  "other": 12
}
```

repos/search:

- name: `^php`

``` sh
$ cli repos/search -d criteria='{"name":"^php"}'
[
  {
    "id": 4592341,
    "name": "php-ext-extmethod",
    "description": "PHP extension is Extension method by closure.",
    "language": "PHP",
    "license": "other",
    "topics": []
  },
  {
    "id": 4622403,
    "name": "php-ext-enum",
    "description": "Enum interface",
    "language": "C",
    "license": "other",
    "topics": []
  },
  {
    "id": 4901205,
    "name": "php-ext-msgpacki",
    "description": "PHP MessagePack Improved Extension",
    "language": "PHP",
    "license": "other",
    "topics": []
  }
]
```

repos/search:

- name: `^php`
- description: `^(?!.*Extension).*`


``` sh
$ cli repos/search -d criteria='{"name":"^php","description":"^(?!.*Extension).*"}'
[
  {
    "id": 4622403,
    "name": "php-ext-enum",
    "description": "Enum interface",
    "language": "C",
    "license": "other",
    "topics": []
  },
  {
    "id": 8596563,
    "name": "php-ext-zopfli",
    "description": "This extension allows Zopfli compression.",
    "language": "PHP",
    "license": "other",
    "topics": []
  },
  {
    "id": 8716976,
    "name": "phpman",
    "description": "PHP manual for command line",
    "language": "Shell",
    "license": "bsd-3-clause",
    "topics": []
  }
]
```

repos/search:

- name: `^php`
- description: `^(?!.*Extension).*`
- language: `PHP`

``` sh
$ cli repos/search -d criteria='{"name":"^php","description":"^(?!.*Extension).*","language":"PHP"}'
[
  {
    "id": 8596563,
    "name": "php-ext-zopfli",
    "description": "This extension allows Zopfli compression.",
    "language": "PHP",
    "license": "other",
    "topics": []
  },
  {
    "id": 26898782,
    "name": "php-ext-jq",
    "description": "This extension allows jq",
    "language": "PHP",
    "license": "mit",
    "topics": []
  },
  {
    "id": 154448532,
    "name": "php-redis-graph",
    "description": "RedisGraph PHP Client",
    "language": "PHP",
    "license": "mit",
    "topics": []
  }
]
```

repos/search:

- name: `^php`
- description: `^(?!.*Extension).*`
- language: `PHP`
- license: `mit`

``` sh
$ cli repos/search -d criteria='{"name":"^php","description":"^(?!.*Extension).*","language":"PHP","license":"mit"}'
[
  {
    "id": 26898782,
    "name": "php-ext-jq",
    "description": "This extension allows jq",
    "language": "PHP",
    "license": "mit",
    "topics": []
  },
  {
    "id": 154448532,
    "name": "php-redis-graph",
    "description": "RedisGraph PHP Client",
    "language": "PHP",
    "license": "mit",
    "topics": []
  }
]
```

repos/search:

- topics: `nginx`

``` sh
$ cli repos/search -d criteria='{"topics":"nginx"}'
[
  {
    "id": 481799679,
    "name": "nginx-jq",
    "description": null,
    "language": "C",
    "license": null,
    "topics": [
      "jq",
      "nginx"
    ]
  }
]
```

Non-existent command.

``` sh
$ cli none
cli: command not found: none
```

Display help messages.

``` sh
$ cli repos -h
Usage: repos [OPTIONS]

Options:
  -d, --data <DATA>  Set data
  -h, --help         Show help message

Data:
  item=.*
  limit=[1-9][0-9]*
  since=[1-9][0-9]*
$
$ cli repos/repo/item --help
Usage: repos/{repo}/{item}
  repo: .*
  item: .*
```

Displays a list of commands.

``` sh
$ cli -h
Usage: <COMMAND>

Command:
  repos
  repos/count
  repos/language
  repos/license
  repos/search
  repos/{repo}
  repos/{repo}/{item}
```

Remove command for command line.

``` sh
$ unfunction cli
$ : [or] unset cli
```

Display command line scripts.

``` sh
$ docker run --rm app generate cli -
#!/usr/bin/env bash

set -e

json=/app/data.json
library_path=/app/modules
...
```

Server mode
-----------

Starts the server.

``` sh
$ docker run --rm --name app -d -p 80:80 app server
```

> Set volume if you do not want to create a Docker image of the application
> ``` sh
> $ docker run --rm --name app -d -p 80:80 -v $PWD:/app ghcr.io/kjdev/jq-api server
> ```

Set commands for the server client.

``` sh
$ client() { url="localhost/${1}"; shift 1; curl -s -G "${@}" "${url}" | jq .;  }
```

> GET access with curl and formatting with jq command

repos:

``` sh
$ client repos
[
  {
    "id": 4109795,
    "name": "apache-mod-sundown",
    "description": "mod_sundown is Markdown handler module for Apache HTTPD Server.",
    "language": "C",
    "license": "apache-2.0",
    "topics": []
  },
  {
    "id": 4198802,
    "name": "apache-mod-v8",
    "description": "mod_v8 is Javascript V8 Engine handler module for Apache HTTPD Server.",
    "language": "C++",
    "license": "apache-2.0",
    "topics": []
  },
  {
    "id": 4319065,
    "name": "apache-mod-mongo",
    "description": "mod_mongo is mongoDB handler module for Apache HTTPD Server.",
    "language": "C++",
    "license": "apache-2.0",
    "topics": []
  }
]
```

repos: specify limit

``` sh
$ client repos -d limit=1
[
  {
    "id": 4109795,
    "name": "apache-mod-sundown",
    "description": "mod_sundown is Markdown handler module for Apache HTTPD Server.",
    "language": "C",
    "license": "apache-2.0",
    "topics": []
  }
]
```

repos: specify limit and since

``` sh
$ client repos -d limit=1 -d since=4109795
[
  {
    "id": 4198802,
    "name": "apache-mod-v8",
    "description": "mod_v8 is Javascript V8 Engine handler module for Apache HTTPD Server.",
    "language": "C++",
    "license": "apache-2.0",
    "topics": []
  }
]
```

repos: specify item

``` sh
$ client repos -d item=name
[
  "apache-mod-sundown",
  "apache-mod-v8",
  "apache-mod-mongo"
]
```

repos/{repo}:

``` sh
$ client repos/php-ext-brotli
{
  "id": 43108981,
  "name": "php-ext-brotli",
  "description": "Brotli Extension for PHP",
  "language": "C",
  "license": "mit",
  "topics": []
}
```

repos/{repo}/{item}:

``` sh
$ client repos/php-ext-brotli/description
"Brotli Extension for PHP"
```

repos/count:

``` sh
$ client repos/count
65
```

repos/language:

``` sh
$ client repos/language
{
  "C": 39,
  "C++": 6,
  "Dockerfile": 1,
  "Go": 2,
  "PHP": 13,
  "Shell": 2
}
```

repos/license:

``` sh
$ client repos/license
{
  "apache-2.0": 10,
  "bsd-2-clause": 1,
  "bsd-3-clause": 2,
  "isc": 2,
  "mit": 25,
  "other": 12
}
```

repos/search:

- name: `^php`

``` sh
$ client repos/search -d criteria='{"name":"^php"}'
[
  {
    "id": 4592341,
    "name": "php-ext-extmethod",
    "description": "PHP extension is Extension method by closure.",
    "language": "PHP",
    "license": "other",
    "topics": []
  },
  {
    "id": 4622403,
    "name": "php-ext-enum",
    "description": "Enum interface",
    "language": "C",
    "license": "other",
    "topics": []
  },
  {
    "id": 4901205,
    "name": "php-ext-msgpacki",
    "description": "PHP MessagePack Improved Extension",
    "language": "PHP",
    "license": "other",
    "topics": []
  }
]
```

repos/search:

- name: `^php`
- description: `^(?!.*Extension).*`

``` sh
$ client repos/search -d criteria='{"name":"^php","description":"^(?!.*Extension).*"}'
[
  {
    "id": 4622403,
    "name": "php-ext-enum",
    "description": "Enum interface",
    "language": "C",
    "license": "other",
    "topics": []
  },
  {
    "id": 8596563,
    "name": "php-ext-zopfli",
    "description": "This extension allows Zopfli compression.",
    "language": "PHP",
    "license": "other",
    "topics": []
  },
  {
    "id": 8716976,
    "name": "phpman",
    "description": "PHP manual for command line",
    "language": "Shell",
    "license": "bsd-3-clause",
    "topics": []
  }
]
```

repos/search:

- name: `^php`
- description: `^(?!.*Extension).*`
- language: `PHP`

``` sh
$ client repos/search -d criteria='{"name":"^php","description":"^(?!.*Extension).*","language":"PHP"}'
[
  {
    "id": 8596563,
    "name": "php-ext-zopfli",
    "description": "This extension allows Zopfli compression.",
    "language": "PHP",
    "license": "other",
    "topics": []
  },
  {
    "id": 26898782,
    "name": "php-ext-jq",
    "description": "This extension allows jq",
    "language": "PHP",
    "license": "mit",
    "topics": []
  },
  {
    "id": 154448532,
    "name": "php-redis-graph",
    "description": "RedisGraph PHP Client",
    "language": "PHP",
    "license": "mit",
    "topics": []
  }
]
```

repos/search:

- name: `^php`
- description: `^(?!.*Extension).*`
- language: `PHP`
- license: `mit`

``` sh
$ client repos/search -d criteria='{"name":"^php","description":"^(?!.*Extension).*","language":"PHP","license":"mit"}'
[
  {
    "id": 26898782,
    "name": "php-ext-jq",
    "description": "This extension allows jq",
    "language": "PHP",
    "license": "mit",
    "topics": []
  },
  {
    "id": 154448532,
    "name": "php-redis-graph",
    "description": "RedisGraph PHP Client",
    "language": "PHP",
    "license": "mit",
    "topics": []
  }
]
```

repos/search:

- topics: `nginx`

``` sh
$ client repos/search -d criteria='{"topics":"nginx"}'
[
  {
    "id": 481799679,
    "name": "nginx-jq",
    "description": null,
    "language": "C",
    "license": null,
    "topics": [
      "jq",
      "nginx"
    ]
  }
]
```

Non-existent command.

```
$ client none
{
  "code": "UNHANDLED_MATCH",
  "message": "Unhandled match path"
}
```

> HTTP Status is  404

Remove command for ther server client.

``` sh
$ unfunction client
$ : [or] unset client
```

Shut down the server.

``` sh
$ docker stop app
```

Display server configration.

``` sh
$ docker run --rm app generate server -
default_type application/json;

jq_json_file /app/data.json;
jq_library_path /app/modules;

location = /repos {
...
```
