import { gql } from "@apollo/client";

export const usersQuery = gql`
  query listUsers {
    users {
      name
    }
  }
`;
