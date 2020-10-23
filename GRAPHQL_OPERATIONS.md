# Extracted GraphQL Operations
## Queries

### listUsers

```graphql
query listUsers {
  users {
    name
  }
}
```

From [src\query.ts:3:31](src\query.ts#L3-L9)
    
## Mutations

### Login

```graphql
mutation Login($name: String!, $password: String!) {
  login(name: $name, password: $password) {
    id
    valid
    jwt
    expiresAt
  }
}
```

From [src\query.ts:11:31](src\query.ts#L11-L20)
    
---
Extracted by [ts-graphql-plugin](https://github.com/Quramy/ts-graphql-plugin)