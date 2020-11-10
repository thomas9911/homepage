import React, { useState } from "react";
// import { usersQuery } from "./query";
import { client } from "./client";
import { ApolloProvider } from "@apollo/client";

import {
  BrowserRouter as Router,
  Switch,
  Route,
  Redirect,
} from "react-router-dom";
import { Routes } from "./routes";
import { AuthContext, sessionAuthContext, useAuthContext } from "./store";
import { LoginPage } from "./Login";
import { Admin } from "./Admin";
import { Header } from "./Header";
import { Posts } from "./Posts";

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

const Home = (): JSX.Element => {
  return (
    <>
      <Header />
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
        <Admin />
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
