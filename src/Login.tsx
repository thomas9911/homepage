import { useMutation } from "@apollo/client";
import { Box, Button, Form, FormField, TextInput } from "grommet";
import React, { useState } from "react";
import { loginQuery } from "./query";
import {
  apolloMutationFunction,
  LoginVariables,
  Login as LoginReturn,
} from "./apollo/types";
import { AuthStore, saveSessionAuthContext, useAuthContext } from "./store";
import { toast } from "react-toastify";
import { useHistory } from "react-router-dom";
import { History } from "history";

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
    throw new Error("Invalid Login");
  }
};

const loginSubmit = (
  value: UserForm,
  doLogin: apolloMutationFunction,
  updateStore: UpdateAuthContext,
  history: History<unknown>
) => {
  const { name = "", password = "" } = value;
  const variables: LoginVariables = { name, password };
  doLogin({ variables })
    .then(({ data }) => {
      updateAuthStore(data as LoginReturn, updateStore);
    })
    .then(() => {
      history.goBack();
    })
    .catch((e) => errorToast(e));
};

const errorToast = (e: Error) => {
  toast.error(e.message, {
    position: "top-right",
    autoClose: 5000,
    hideProgressBar: true,
    closeOnClick: true,
    pauseOnHover: true,
    draggable: true,
  });
};

const InnerLoginPage = (): JSX.Element => {
  const [value, setValue] = useState({ name: "", password: "" } as UserForm);
  const [doLogin] = useMutation(loginQuery);
  const { updateStore } = useAuthContext();
  const history = useHistory();

  return (
    <Box
      direction="row"
      border={{ color: "brand", size: "xlarge" }}
      pad="xlarge"
    >
      <Form
        value={value}
        onChange={(nextValue) => setValue(nextValue as any)}
        // onReset={() => setValue({})}
        onSubmit={({ value }) =>
          loginSubmit(value as UserForm, doLogin, updateStore, history)
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
          {/* <Button type="reset" label="Reset" /> */}
        </Box>
      </Form>
    </Box>
  );
};

export const LoginPage = InnerLoginPage;
