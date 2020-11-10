import { ApolloError, useMutation } from "@apollo/client";
import { Box, Button, Form, FormField, TextInput, Heading } from "grommet";
import React from "react";
import { createUser } from "../query";
import { errorToast, successToast } from "../toasters";

interface CreateUserInput {
  username: string;
  password: string;
}

const defaultCreateUserInput: CreateUserInput = { username: "", password: "" };

export const CreateUserForm = (): JSX.Element => {
  const [value, setValue] = React.useState<CreateUserInput>(
    defaultCreateUserInput
  );
  const options = {
    onCompleted: (): void => successToast("User created"),
    onError: (e: ApolloError): void => errorToast(e),
  };

  const [newUser] = useMutation(createUser, options);

  return (
    <Box
      direction="row"
      border={{ color: "brand", size: "large" }}
      pad="medium"
    >
      <Form
        value={value}
        onChange={(nextValue): void => setValue(nextValue as CreateUserInput)}
        onReset={(): void => setValue(defaultCreateUserInput)}
        onSubmit={({ value }): void => {
          newUser({ variables: value as CreateUserInput });
        }}
      >
        <Heading level={2}>Create a new user</Heading>
        <FormField name="name" htmlFor="username-id" label="Name">
          <TextInput id="username-id" name="username" required />
        </FormField>
        <FormField name="password" htmlFor="password-id" label="Password">
          <TextInput id="password-id" name="password" required />
        </FormField>
        <Box direction="row" gap="medium">
          <Button type="submit" primary label="Submit" />
          <Button type="reset" label="Reset" />
        </Box>
      </Form>
    </Box>
  );
};
