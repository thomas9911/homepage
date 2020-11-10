import { ApolloError, useMutation } from "@apollo/client";
import {
  Box,
  Button,
  Form,
  FormField,
  TextInput,
  Heading,
  TextArea,
} from "grommet";
import React from "react";
import { createPost } from "../query";
import { errorToast, successToast } from "../toasters";

interface CreatePostInput {
  title: string;
  content: string;
}

const defaultCreatePostInput: CreatePostInput = { title: "", content: "" };

export const CreatePostForm = (): JSX.Element => {
  const [value, setValue] = React.useState<CreatePostInput>(
    defaultCreatePostInput
  );
  const options = {
    onCompleted: (): void => successToast("Post created"),
    onError: (e: ApolloError): void => errorToast(e),
  };

  const [newPost] = useMutation(createPost, options);

  return (
    <Box
      direction="row"
      border={{ color: "brand", size: "large" }}
      pad="medium"
    >
      <Form
        value={value}
        onChange={(nextValue): void => setValue(nextValue as CreatePostInput)}
        onReset={(): void => setValue(defaultCreatePostInput)}
        onSubmit={({ value }): void => {
          newPost({ variables: value as CreatePostInput });
        }}
      >
        <Heading level={2}>Create a new post</Heading>
        <FormField name="title" htmlFor="title-id" label="Title">
          <TextInput id="title-id" name="title" required />
        </FormField>
        <FormField name="content" htmlFor="content-id" label="Content">
          <TextArea id="content-id" name="content" required rows={5} />
        </FormField>
        <Box direction="row" gap="medium">
          <Button type="submit" primary label="Submit" />
          <Button type="reset" label="Reset" />
        </Box>
      </Form>
    </Box>
  );
};
