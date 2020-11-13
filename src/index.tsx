import React from "react";
import { hydrate, render } from "react-dom";
// import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import { Grommet } from "grommet";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const theme = {
  global: {
    colors: {
      brand: "#228BE6",
    },
    font: {
      family: "Roboto",
      size: "18px",
      height: "20px",
    },
  },
};

// ReactDOM.render(
//   <Grommet theme={theme}>
//     <React.StrictMode>
//       <App />
//     </React.StrictMode>
//   </Grommet>,
//   document.getElementById("root")
// );

const IndexApp = (): JSX.Element => {
  return (
    <Grommet theme={theme}>
      <ToastContainer />
      <React.StrictMode>
        <App />
      </React.StrictMode>
    </Grommet>
  );
};

const rootElement = document.getElementById("root");

if (rootElement?.hasChildNodes()) {
  hydrate(<IndexApp />, rootElement);
} else {
  render(<IndexApp />, rootElement);
}

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
