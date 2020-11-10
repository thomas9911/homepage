import React from "react";

import { useQuery } from "@apollo/client";
import { postsQuery } from "./query";
import { toast } from "react-toastify";
import { Heading, InfiniteScroll, Main, Paragraph } from "grommet";
import { Posts as TPosts } from "./apollo/types";

export const Posts = (): JSX.Element => {
  const { loading, error, data, fetchMore } = useQuery(postsQuery, {
    variables: { limit: 5, skip: 0 },
  });

  if (loading) return <p>Loading ...</p>;

  if (error) {
    toast.error(error.message);
    return <div></div>;
  } else {
    return (
      <InfiniteScroll
        items={data.posts}
        step={5}
        onMore={() =>
          fetchMore({
            variables: {
              skip: data.posts.length,
            },
            updateQuery: (prev: TPosts, { fetchMoreResult }) => {
              if (!fetchMoreResult) return prev;
              return Object.assign({}, prev, {
                posts: [
                  ...(prev.posts || []),
                  ...(fetchMoreResult.posts || []),
                ],
              });
            },
          })
        }
      >
        {(value: any) => (
          <Main pad="large" key={value?.id || "1234"}>
            <Heading level={3}>{value?.title || ""}</Heading>
            <Paragraph margin="small">{value?.content || ""}</Paragraph>
          </Main>
        )}
      </InfiniteScroll>
    );
  }
};
