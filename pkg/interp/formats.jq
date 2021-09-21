# note this is a "dynamic" include, outputted string will be used as source

( [ ( _registry.groups
    | to_entries[]
    # TODO: nicer way to skip "all" which also would override builtin all/*
    | select(.key != "all")
    | "def \(.key)($opts): _decode(\(.key | tojson); $opts);"
    , "def \(.key): _decode(\(.key | tojson); {});"
    )
  , ( _registry.formats[]
    | select(.files)
    | .files[]
    )
  ]
  | join("\n")
)
