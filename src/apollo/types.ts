import { MutationFunctionOptions, FetchResult } from "@apollo/client";
export * from "../__generated__/list-users";
export * from "../__generated__/login";
export * from "../__generated__/posts";

export type apolloMutationFunction = (
  options?: MutationFunctionOptions<any, Record<string, any>> | undefined
) => Promise<FetchResult<any, Record<string, any>, Record<string, any>>>;
