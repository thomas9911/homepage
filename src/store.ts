import { createContext, useContext } from "react";
import { Map } from "immutable";
import moment, { Moment } from "moment";

const AUTH_KEY = "auth";

export class AuthStore {
  userId?: string;
  token?: string;
  expiry?: Moment;
  user?: Map<string, string>;

  constructor(input?: Map<string, string> | Record<string, string>) {
    if (input) {
      const mapInput =
        input instanceof Map
          ? (input as Map<string, string>)
          : Map(input as Record<string, string>);

      this.userId = mapInput.get("userId");
      this.token = mapInput.get("token");
      this.expiry = moment(mapInput.get("expiry"));
      this.user = mapInput;
    }
  }

  isSet(): boolean {
    return !this.isEmpty();
  }

  isEmpty(): boolean {
    return !this.userId;
  }

  isExpired(): boolean {
    if (this.expiry) {
      return this.expiry.isBefore(moment());
    }

    return true;
  }

  isNotExpired(): boolean {
    return !this.isExpired();
  }

  isValid(): boolean {
    return this.isSet() && this.isNotExpired();
  }

  clear(): void {
    this.userId = undefined;
    this.token = undefined;
    this.expiry = undefined;
    this.user = undefined;
  }

  asObject(): object {
    return {
      userId: this.userId,
      token: this.token,
      expiry: this.expiry,
      user: this.user?.toJS(),
    };
  }

  asJSON(): string {
    return JSON.stringify(this.asObject());
  }
}

type UpdateStore = React.Dispatch<React.SetStateAction<AuthStore>>;

const defaultUpdateStore: UpdateStore = () => {
  // overriden by the useState:
  // ```js
  // const [store, updateStore] = useState(sessionAuthContext());
  // ```
  //
  // ```jsx
  // <AuthContext.Provider value={{ store, updateStore }}>
  // ```
};

const defaultValue = {
  store: new AuthStore(),
  updateStore: defaultUpdateStore,
};

export const AuthContext = createContext(defaultValue);

export const sessionAuthContext = (): AuthStore => {
  const item = sessionStorage.getItem(AUTH_KEY);
  if (item) {
    return new AuthStore(JSON.parse(item));
  } else {
    return new AuthStore();
  }
};

export const saveSessionAuthContext = (auth: AuthStore): void => {
  sessionStorage.setItem(AUTH_KEY, auth.asJSON());
};

export const useAuthContext = (): {
  store: AuthStore;
  updateStore: UpdateStore;
} => useContext(AuthContext);
