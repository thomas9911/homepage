import React from "react";

import { useQuery } from "@apollo/client";
import { postsQuery } from "./query";
import { Heading, InfiniteScroll, Main, Paragraph } from "grommet";
import { Posts as TPosts } from "./apollo/types";
import { errorToast } from "./toasters";

export const Posts = (): JSX.Element => {
  const { loading, error, data, fetchMore } = useQuery(postsQuery, {
    variables: { limit: 5, skip: 0 },
  });

  if (loading) return <Paragraph margin="large">Loading ...</Paragraph>;

  if (error) {
    errorToast(error);
    return <Paragraph margin="large">Failed to load Posts</Paragraph>;
  } else {
    const typedData: TPosts = data;
    const posts = typedData.posts || [];

    return (
      <InfiniteScroll
        items={posts}
        step={5}
        onMore={(): void => {
          fetchMore({
            variables: {
              skip: posts.length,
            },
            // updateQuery: (prev: TPosts, { fetchMoreResult }) => {
            //   if (!fetchMoreResult) return prev;
            //   return Object.assign({}, prev, {
            //     posts: [
            //       ...(prev.posts || []),
            //       ...(fetchMoreResult.posts || []),
            //     ],
            //   });
            // },
          });
        }}
      >
        {(value: unknown): JSX.Element => {
          const { id = "1234", title = "", content = "" } = value as {
            id: string;
            title: string;
            content: string;
          };

          return (
            <Main pad="large" key={id}>
              <Heading level={3}>{title}</Heading>
              <Paragraph margin="small">{content}</Paragraph>
            </Main>
          );
        }}
      </InfiniteScroll>
    );
  }
};
