import React from "react";
import { ApolloProvider } from "react-apollo";
import { ApolloProvider as ApolloProviderHooks } from "react-apollo-hooks";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { client } from "./apolloClient";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import store from "./store/store";

ReactDOM.render(
  <ApolloProvider client={client}>
    <ApolloProviderHooks client={client}>
      <Provider store={store}>
        <App />
      </Provider>
    </ApolloProviderHooks>
  </ApolloProvider>,
  document.getElementById("root")
);

serviceWorker.unregister();
