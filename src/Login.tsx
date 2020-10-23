import { useMutation } from "@apollo/client";
import { Box, Button, Form, FormField, TextInput } from "grommet";
import React, { useContext, useState } from "react";
import { loginQuery } from "./query";
import {
  apolloMutationFunction,
  LoginVariables,
  Login as LoginReturn,
} from "./apollo/types";
import { AuthContext, AuthStore, saveSessionAuthContext } from "./store";

type UpdateAuthContext = React.Dispatch<React.SetStateAction<AuthStore>>;

interface UserForm {
  name?: string;
  password?: string;
}

const updateAuthStore = (
  { login }: LoginReturn,
  updateStore: UpdateAuthContext
) => {
  if (login?.valid) {
    const updatedStorage = new AuthStore({
      userId: login?.id,
      token: login?.jwt,
      expiry: login?.expiresAt,
    });

    updateStore(updatedStorage);
    saveSessionAuthContext(updatedStorage);
  } else {
    throw "Invalid Login";
  }
};

const loginSubmit = (
  value: UserForm,
  doLogin: apolloMutationFunction,
  updateStore: UpdateAuthContext
) => {
  const { name = "", password = "" } = value;
  const variables: LoginVariables = { name, password };
  doLogin({ variables })
    .then(({ data }) => {
      updateAuthStore(data as LoginReturn, updateStore);
    })
    .catch((e) => console.log(e));
};

export const LoginPage = (): JSX.Element => {
  const [value, setValue] = useState({} as UserForm);
  const [doLogin] = useMutation(loginQuery);
  const { store, updateStore } = useContext(AuthContext);

  return (
    <Form
      value={value}
      onChange={(nextValue) => setValue(nextValue as any)}
      onReset={() => setValue({})}
      onSubmit={({ value }) =>
        loginSubmit(value as UserForm, doLogin, updateStore)
      }
    >
      <FormField
        name="name"
        htmlFor="username-id"
        label="Name"
        required={true}
        placeholder="Username"
      >
        <TextInput id="username-id" name="name" />
      </FormField>
      <FormField
        name="password"
        htmlFor="password-id"
        label="Password"
        required={true}
        placeholder="Password"
      >
        <TextInput id="password-id" name="password" type="password" />
      </FormField>
      <Box direction="row" gap="medium">
        <Button type="submit" primary label="Submit" />
        <Button type="reset" label="Reset" />
      </Box>
    </Form>
  );
};
