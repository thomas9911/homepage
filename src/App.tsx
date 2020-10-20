import React from "react";
import logo from "./logo.svg";
import "./App.css";
import { usersQuery } from "./query";
import { client } from "./client";
import { ApolloProvider } from "@apollo/client";

function App(): JSX.Element {
  client
    .query({
      query: usersQuery,
    })
    .then((result) => console.log(result));

  return (
    <ApolloProvider client={client}>
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.tsx</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    </ApolloProvider>
  );
}

export default App;
