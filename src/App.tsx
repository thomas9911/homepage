import React, { useState } from "react";
// import { usersQuery } from "./query";
import { client } from "./client";
import { ApolloProvider } from "@apollo/client";
import { Box, BoxProps, Button } from "grommet";
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

// const InnerApp = (): JSX.Element => {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.tsx</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// };

// const LoginPage = (): JSX.Element => {
//   return <div>

//   </div>
// }

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
  // const { store } = useAuthContext;

  // // return <Link to={Routes.Login}>XDXDXD</Link>
  // return  <Redirect from={Routes.Admin} to={Routes.Login} />
  return <div>XDXD</div>;
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

const Home = (): JSX.Element => {
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
