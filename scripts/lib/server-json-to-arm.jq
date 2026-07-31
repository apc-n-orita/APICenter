{
  properties: {
    title: .name,
    kind: "mcp",
    description: .description,
    summary: .description,
    lifecycleStage: "design",
    packages: [ .packages[] | {
      registry_name: .registryType,
      name: .identifier,
      version: .version,
      runtime_hint: .runtimeHint,
      transport: .transport,
      runtime_arguments: [ (.runtimeArguments // [])[] | {
        type: .type,
        name: .name,
        is_required: (.isRequired // false),
        format: (.format // "string"),
        is_repeated: (.isRepeated // false),
        is_secret: (.isSecret // false),
        variables: (.variables // {})
      }],
      package_arguments: (.packageArguments // []),
      environment_variables: [ (.environmentVariables // [])[] | {
        name: .name,
        is_required: (.isRequired // false),
        is_secret: (.isSecret // false),
        format: (.format // "string")
      }]
    }]
  }
}
