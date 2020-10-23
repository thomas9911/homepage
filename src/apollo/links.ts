import { setContext } from "@apollo/client/link/context";
import { onError } from "@apollo/client/link/error";

const AsyncTokenLookup = (): Promise<any> => {
  // do login
  return new Promise((res) => res);
};

// cached storage for the user token
let token: string | null;
const withToken = setContext(() => {
  // if you have a cached value, return it immediately
  if (token) return { token };

  return AsyncTokenLookup().then((userToken) => {
    token = userToken;
    return { token };
  });
});

const resetToken = onError(({ networkError }) => {
  if (
    networkError &&
    "statusCode" in networkError &&
    networkError.statusCode === 401
  ) {
    // remove cached token on 401 from the server
    token = null;
  }
});

const authFlowLink = withToken.concat(resetToken);
