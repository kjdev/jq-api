jq API
======

API system with JSON files and [jq](https://stedolan.github.io/jq) filters.

Required Commands
-----------------

- bash
- jq
- nginx ([jq module](https://github.com/kjdev/nginx-jq))

Build Docker image
------------------

Build the Docker image.

``` sh
$ docker build -t ghcr.io/kjdev/jq-api .
```

A JSON file of configuration and data is also required to run.

> ``` dockerfile
> WORKDIR /app
> ONBUILD COPY . /app/
> ```
>
> Place the files in WORKDIR (/app) or
> create a Docker image for execution with ONBUILD.

Configuration
-------------

config.json:

``` json
{
  "json": "[JSON FILEPATH]",
  "library_path": "[JQ LIBRARY PATH]",
  "arguments": {
    "[VARIABLE NAME]": {
      "pattern": "[VARIABLE PATTERN]"
    },
  },
  "routes": {
    "[API PATH]": {
      "parameters": [
        "[VARIABLE NAME]"
      ],
      "filter": "[JQ FILTER]"
    },
  },
  "settings": {
    "cli": {
      "options": "[JQ OPTIONS FOR CLI]"
    },
    "server": {
      "error": {
        "filter": "[JQ FILTER FOR SERVER ERROR]"
      }
    }
  }
}
```

### json

The `json` key sets the JSON file that will serve as the data source.

``` json
{
  "json": "./path/to/data.json"
}
```

> Relative paths are converted to absolute paths at runtime
> using the `realpath` command.

### library_path

The `library_path` key sets the module search path at jq runtime.

``` json
{
  "library_path": "./path/to/dir"
}
```

> Relative paths are converted to absolute paths at runtime
> using the `realpath` command.

If there is no module file, it may be left unset.

### arguments

The `arguments` objec sets all variables used at jq runtime.

``` json
{
  "arguments": {
    "name": {}
  }
}
```

A variable object can set the pattern of the variable with the `pattern` key.

``` json
{
  "arguments": {
    "name": {
      "pattern": "number"
    }
  }
}
```

Possible values are `number`, `json`, and regular expressions.

The value of pattern is used by bash for regular expression comparison
during command line processing.

``` bash
if [[ ! "${data}" =~ ^${regex}$ ]]; ..
```

Value handling:

- `number`: `[1-9][0-9]*`
- `json`: `{.*}`
- regex: `regex`
- not specified: `.*`

### routes

The `routes` object sets the API endpoints.

The `filter` key in the endpoint object sets the filter at jq runtime.

``` json
{
  "routes": {
    "endpoint": {
      "filter": "."
    }
  } 
}
```

The `parameters` key of the endpoint object sets variables to be used during
at jq runtime.

The values must be set in the arguments object.

``` json
{
  "routes": {
    "endpoint": {
      "parameters": [
        "id"
      ],
      "filter": ".[] | select(.id == $id)"
    }
  } 
}
```

Set variables to be used by enclosing them in braces ({}) in the endpoint.

``` json
{
  "routes": {
    "id/{id}": {
      "filter": ".[] | select(.id == $id)"
    }
  } 
}
```

### settings

The `settings` object can be used to configure additional
command line or server settings.

The `cli.options` object allows you to set jq options for command line runtime.

``` json
{
  "settings": {
    "cli": {
      "options": "-c -R"
    }
  }
}
```

The `server.cors` object can set CORS response headers.

``` json
{
  "settings": {
    "server": {
      "cors": {
        "origin": "^https?://localhost",
        "methods": "GET",
        "headers": "Origin",
        "credentials": true
      }
    }
  }
}
```

- origin: Output `Access-Control-Allow-Origin` header matching
  the regular expression matching `$http_origin` (or `*` if not set).
- methods: Value of the `Access-Control-Allow-Methods` header
  (or `*` if not set).
- headers: value of the `Access-Control-Allow-Headers` header
  (or `*` if not set)
- credentials: If true, output the `Access-Control-Allow-Credentials: true`
  header.

The `server.error` object allows you to configure what to do in case of
server errors.

``` json
{
  "settings": {
    "server": {
      "error": {
        "filter": "{\"code\":\"UNHANDLED_MATCH\",\"message\":\"Unhandled match path\"}"
      }
    }
  }
}
```

Example
-------

> other examples: [example](example/README.md)

Create a JSON data file.

``` sh
$ cat << EOF > data.json
[
  { "id": 1, "value": "first" },
  { "id": 2, "value": "second" },
  { "id": 3, "value": "third" }
]
EOF
```

Create configuration JSON file.

``` sh
$ cat << EOF > config.json
{
  "json": "./data.json",
  "arguments": {
    "id": {}
  },
  "routes": {
    "id": {
      "parameters": [ "id" ],
      "filter": ".[] | if \$id != \"\" then select(.id == (\$id|tonumber)) else . end"
    },
    "id/{id}": {
      "filter": ".[] | select(.id == (\$id|tonumber))"
    }
  },
  "settings": {
    "cli": { "options": "-c" }
  }
}
EOF
```

Place the file in WORKDIR and execute it on the command line.

``` sh
$ : id
$ docker run --rm -v $PWD:/app ghcr.io/kjdev/jq-api cli id -d id=1
{"id":1,"value":"first"}
$ : id/{id}
$ docker run --rm -v $PWD:/app ghcr.io/kjdev/jq-api cli id/2
{"id":2,"value":"second"}
```

Place a file in WORKDIR to start the API server.

``` sh
$ docker run --rm --name app -d -p 80:80 -v $PWD:/app ghcr.io/kjdev/jq-api server
```

Access the API server.

``` sh
$ : id
$ curl -G localhost/id -d id=2
{"id":2,"value":"second"}
$ : id/{id}
$ curl -G localhost/id/3
{"id":3,"value":"third"}
```

Stop the API server.

``` sh
$ docker stop app
```
