
def repos(filter; item; limit; since):
  [
    limit(try (limit | tonumber) catch 3;
      [
        .[]
        | filter
        | if since != "" then select(."id" > (since | tonumber)) else . end
      ]
      | sort_by(."id")
      | .[]
      | if item == "" then {id:."id", name:."name", description:."description", language:."language", license:."license"."key", topics:."topics"} else .[item] end
    )
  ]
  ;

def list(item; limit; since):
  repos(
    .;
    item;
    limit;
    since
  )
  ;

def repo(repo; item):
  repos(
    select(."name" == (repo | tostring));
    item;
    1;
    ""
  ) | .[0]
  ;

def search(criteria; item; limit; since):
  (try (criteria | fromjson) catch {}) as $criteria |
  repos(
    if ($criteria | has("name")) then select(."name" | tostring | test($criteria."name" | tostring)) else . end
    | if ($criteria | has("description")) then select(."description" | tostring | test($criteria."description" | tostring)) else . end
    | if ($criteria | has("language")) then select(."language" | tostring | test($criteria."language" | tostring)) else . end
    | if ($criteria | has("license")) then select(."license"."key" | tostring | test($criteria."license" | tostring)) else . end
    | if ($criteria | has("topics")) then select(."topics"[] | tostring | test($criteria."topics" | tostring )) else . end
    ;
    item;
    limit;
    since
  )
  ;

def count:
  . | length
  ;

def language:
  [
    [
      .[] | select(has("language"))
    ]
    | group_by(."language")[]
    | {"key":(.[0] | ."language"), "value":length}
    | select(.key != null)
  ] | from_entries
  ;

def license:
  [
    [
      .[] | select(has("license")) | ."license" | select(has("key"))
    ]
    | group_by(."key")[]
    | {"key":(.[0] | ."key"), "value":length}
    | select(.key != null)
  ] | from_entries
  ;
