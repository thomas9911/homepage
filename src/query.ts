import { gql } from "@apollo/client";

export const usersQuery = gql`
  {
    users {
      name
    }
  }
`;
