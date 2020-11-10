import { MutationFunctionOptions, FetchResult } from "@apollo/client";
export * from "../__generated__/list-users";
export * from "../__generated__/new-user";
export * from "../__generated__/login";
export * from "../__generated__/posts";
export * from "../__generated__/new-post";

export type apolloMutationFunction = (
  options?: MutationFunctionOptions<any, Record<string, any>> | undefined
) => Promise<FetchResult<any, Record<string, any>, Record<string, any>>>;

export type Post = {
  id: string | null;
  title: string | null;
  content: string | null;
  updatedAt: string | null;
  createdAt: string | null;
};
