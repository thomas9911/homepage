import React from "react";
// import logo from "./logo.svg";
// import "./App.css";
import { usersQuery } from "./query";
import { client } from "./client";
import { ApolloProvider } from "@apollo/client";
import { Box, BoxProps, Button, Heading } from "grommet";
import {
  Notification,
  Home as HomeIcon,
  VmMaintenance,
  GraphQl as GraphQlIcon,
} from "grommet-icons";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import { Routes } from "./routes";

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

const MainSwitch = (): JSX.Element => {
  return (
    <Switch>
      {/* <Route path="/about">
    <About />
  </Route>
  <Route path="/users">
    <Users />
  </Route> */}
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

const App = (): JSX.Element => {
  // client
  //   .query({
  //     query: usersQuery,
  //   })
  //   .then((result) => console.log(result));

  return (
    <ApolloProvider client={client}>
      <Router forceRefresh={true}>
        {/* <Home /> */}
        <MainSwitch />
      </Router>
    </ApolloProvider>
  );
};

export default App;
