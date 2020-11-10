import { Heading } from "grommet";
import React from "react";
import { CreatePostForm } from "./Admin/CreatePost";
import { CreateUserForm } from "./Admin/CreateUser";
import { Header } from "./Header";

export const Admin = (): JSX.Element => {
  return (
    <>
      <Header />
      <Heading>ADMIN PAGE</Heading>
      <CreateUserForm />
      <CreatePostForm />
    </>
  );
};
