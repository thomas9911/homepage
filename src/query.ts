import { gql } from "@apollo/client";

export const usersQuery = gql`
  query listUsers {
    users {
      name
    }
  }
`;

export const loginQuery = gql`
  mutation Login($name: String!, $password: String!) {
    login(name: $name, password: $password) {
      id
      valid
      jwt
      expiresAt
    }
  }
`;

export const postsQuery = gql`
  query Posts($limit: Int, $skip: Int) {
    posts(limit: $limit, skip: $skip) {
      id
      title
      content
      updatedAt
      createdAt
    }
  }
`;
