import { createContext, useContext } from "react";
import { Map } from "immutable";
// import moment, { Moment } from "moment";
import { DateTime } from "luxon";

const AUTH_KEY = "auth";

type stringOrNull = string | undefined | null;

export class AuthStore {
  userId?: string;
  token?: string;
  expiry?: DateTime;
  user?: Map<string, stringOrNull>;

  constructor(
    input?: Map<string, stringOrNull> | Record<string, stringOrNull>
  ) {
    if (input) {
      const mapInput =
        input instanceof Map
          ? (input as Map<string, string>)
          : Map(input as Record<string, string>);

      this.userId = mapInput.get("userId");
      this.token = mapInput.get("token");
      this.expiry = DateTime.fromISO(
        mapInput.get("expiry") || "1970-01-01T:00:00:00Z"
      );
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
      // return this.expiry.isBefore(moment());
      // return Interval.fromDateTimes(this.expiry).isBefore()
      return DateTime.fromISO("1970-01-01T00:00:00Z")
        .until(this.expiry)
        .isBefore(DateTime.utc());
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
