import { createContext } from "react";
import { Map } from "immutable";
import moment, { Moment } from "moment";

const AUTH_KEY = "auth";

export class AuthStore {
  userId?: string;
  token?: string;
  expiry?: Moment;
  user?: Map<string, any>;

  constructor(input?: Map<string, any> | Record<string, any>) {
    if (input) {
      const mapInput =
        input instanceof Map ? (input as Map<string, any>) : Map(input);

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

  asObject(): Record<string, any> {
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

const defaultUpdateStore: React.Dispatch<React.SetStateAction<
  AuthStore
>> = () => {};
const defaultValue = {
  store: new AuthStore(),
  updateStore: defaultUpdateStore,
};

export const AuthContext = createContext(defaultValue);

export const sessionAuthContext = () => {
  const item = sessionStorage.getItem(AUTH_KEY);
  if (item) {
    return new AuthStore(JSON.parse(item));
  } else {
    return new AuthStore();
  }
};

export const saveSessionAuthContext = (auth: AuthStore) => {
  sessionStorage.setItem(AUTH_KEY, auth.asJSON());
};
