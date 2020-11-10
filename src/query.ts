import { gql } from "@apollo/client";

export const usersQuery = gql`
  query ListUsers {
    users {
      name
    }
  }
`;

export const createUser = gql`
  mutation NewUser($username: String!, $password: String!) {
    createUser(name: $username, password: $password) {
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

export const createPost = gql`
  mutation NewPost($title: String!, $content: String!) {
    createPost(title: $title, content: $content) {
      title
    }
  }
`;
