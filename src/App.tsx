import React, { useState } from "react";
// import { usersQuery } from "./query";
import { client } from "./client";
import { ApolloProvider, useQuery } from "@apollo/client";
import {
  Box,
  BoxProps,
  Button,
  Heading,
  InfiniteScroll,
  Main,
  Paragraph,
} from "grommet";
import {
  Notification,
  Home as HomeIcon,
  VmMaintenance,
  GraphQl as GraphQlIcon,
} from "grommet-icons";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  Redirect,
} from "react-router-dom";
import { Routes } from "./routes";
import { AuthContext, sessionAuthContext, useAuthContext } from "./store";
import { LoginPage } from "./Login";
import { postsQuery } from "./query";
import { List } from "immutable";
import { Posts as TPosts } from "./apollo/types";
import { toast } from "react-toastify";

const PrivateRoute = ({
  children,
  ...rest
}: Record<string, any>): JSX.Element => {
  const { store } = useAuthContext();

  return (
    <Route
      {...rest}
      render={({ location }): JSX.Element =>
        store.isValid() ? (
          children
        ) : (
          <Redirect
            push
            to={{
              pathname: Routes.Login,
              state: { from: location },
            }}
          />
        )
      }
    />
  );
};

const AdminPage = (): JSX.Element => {
  return (
    <>
      <AppHeader />
      <div>ADMIN PAGE</div>
    </>
  );
};

const AppBox = (
  props: JSX.IntrinsicAttributes &
    BoxProps &
    React.ClassAttributes<HTMLDivElement> &
    React.HTMLAttributes<HTMLDivElement>
): JSX.Element => {
  return (
    <Box
      direction="row"
      justify="between"
      align="center"
      elevation="medium"
      pad={{ vertical: "small", horizontal: "medium" }}
      {...props}
    />
  );
};

const Posts = (): JSX.Element => {
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

const AppHeader = (): JSX.Element => {
  return (
    <AppBox>
      <Link to={Routes.Home}>
        <HomeIcon />
      </Link>
      <Button icon={<Notification />} onClick={() => {}} />
      <Button></Button>
      <Link to={Routes.Graphql}>
        <GraphQlIcon />
      </Link>
      <Link to={Routes.Admin}>
        {/* <Link to="https://google.com"> */}
        <VmMaintenance />
      </Link>
    </AppBox>
  );
};

const Home = (): JSX.Element => {
  return (
    <>
      <AppHeader />
      <Posts />
    </>
  );
};

const MainSwitch = (props: any): JSX.Element => {
  return (
    <Switch>
      {/* <Route path="/about">
    <About />
  </Route>
  <Route path="/users">
    <Users />
  </Route> */}

      <PrivateRoute path={Routes.Admin}>
        <AdminPage />
      </PrivateRoute>
      <Route path={Routes.Login}>
        <LoginPage />
      </Route>
      <Route path={Routes.Home}>
        <Home />
      </Route>
      {/* <Route
        path={Routes.Graphql}
        component={() => {
          window.location.href = "http://localhost:4000/api";
          return null;
        }}
      /> */}
    </Switch>
  );
};

// const InnerApp = (): JSX.Element => {
//   return <AuthedApp />;
// };

// const UnAuthedApp = (): JSX.Element => {
//   console.log("unauthed");
//   return (
//     <ApolloProvider client={client()}>
//       <MainSwitch />
//     </ApolloProvider>
//   );
// };

const AuthedApp = (): JSX.Element => {
  const { store } = useAuthContext();
  return (
    <ApolloProvider client={client(store.token)}>
      <MainSwitch />
    </ApolloProvider>
  );
};

const App = (): JSX.Element => {
  // client
  //   .query({
  //     query: usersQuery,
  //   })
  //   .then((result) => console.log(result));
  const [store, updateStore] = useState(sessionAuthContext());
  // const [store, updateStore] = useState(new AuthStore());

  return (
    <AuthContext.Provider value={{ store, updateStore }}>
      <Router forceRefresh={true}>
        {/* <Home /> */}
        <AuthedApp />
      </Router>
    </AuthContext.Provider>
  );
};

export default App;
