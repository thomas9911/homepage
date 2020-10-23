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
