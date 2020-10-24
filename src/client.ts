import {
  ApolloClient,
  InMemoryCache,
  NormalizedCacheObject,
} from "@apollo/client";

import { url } from "./config.json";

export const client = (token?: string): ApolloClient<NormalizedCacheObject> => {
  const headers: Record<string, string> | undefined = token
    ? { authorization: token }
    : undefined;
  return new ApolloClient({
    uri: url,
    cache: new InMemoryCache(),
    headers,
  });
};
