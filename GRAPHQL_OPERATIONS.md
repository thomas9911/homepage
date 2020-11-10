# Extracted GraphQL Operations
## Queries

### ListUsers

```graphql
query ListUsers {
  users {
    name
  }
}
```

From [src\query.ts:3:31](src\query.ts#L3-L9)
    

### Posts

```graphql
query Posts($limit: Int, $skip: Int) {
  posts(limit: $limit, skip: $skip) {
    id
    title
    content
    updatedAt
    createdAt
  }
}
```

From [src\query.ts:30:31](src\query.ts#L30-L40)
    
## Mutations

### NewUser

```graphql
mutation NewUser($username: String!, $password: String!) {
  createUser(name: $username, password: $password) {
    name
  }
}
```

From [src\query.ts:11:31](src\query.ts#L11-L17)
    

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

From [src\query.ts:19:31](src\query.ts#L19-L28)
    
---
Extracted by [ts-graphql-plugin](https://github.com/Quramy/ts-graphql-plugin)