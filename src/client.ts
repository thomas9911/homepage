import {
  ApolloClient,
  InMemoryCache,
  ApolloClientOptions,
} from "@apollo/client";

import { url } from "./config.json";

export const client = (token?: string): ApolloClient<any> => {
  const headers: Record<string, string> | undefined = token
    ? { authorization: token }
    : undefined;
  return new ApolloClient({
    uri: url,
    cache: new InMemoryCache(),
    headers,
  });
};
