/* eslint-disable */
/* This is an autogenerated file. Do not edit this file directly! */
export type Posts = {
  posts:
    | ({
        id: string | null;
        title: string | null;
        content: string | null;
        updatedAt: string | null;
        createdAt: string | null;
      } | null)[]
    | null;
};
export type PostsVariables = {
  limit?: number | null;
  skip?: number | null;
};