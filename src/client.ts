import {
  ApolloClient,
  InMemoryCache,
  NormalizedCacheObject,
} from "@apollo/client";
import { Post } from "./apollo/types";

import { url } from "./config.json";

export const client = (token?: string): ApolloClient<NormalizedCacheObject> => {
  const headers: Record<string, string> | undefined = token
    ? { authorization: `Bearer ${token}` }
    : undefined;
  return new ApolloClient({
    uri: url,
    cache: new InMemoryCache({
      typePolicies: {
        Query: {
          fields: {
            posts: {
              keyArgs: false,
              merge(existing: Post[] = [], incoming: Post[]): Post[] {
                return [...existing, ...incoming];
              },
            },
          },
        },
      },
    }),
    headers,
  });
};
