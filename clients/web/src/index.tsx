import React from "react";
import { ApolloProvider } from "react-apollo";
import { ApolloProvider as ApolloProviderHooks } from "react-apollo-hooks";
import ReactDOM from "react-dom";
import { Provider as ReduxProvider } from "react-redux";
import { client } from "./apolloClient";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import store from "./redux/store";
import { ReduxStoreProvider } from "./redux/context/ReduxStoreContext";

ReactDOM.render(
  <ApolloProvider client={client}>
    <ApolloProviderHooks client={client}>
      <ReduxProvider store={store}>
        <ReduxStoreProvider>
          <App />
        </ReduxStoreProvider>
      </ReduxProvider>
    </ApolloProviderHooks>
  </ApolloProvider>,
  document.getElementById("root")
);

serviceWorker.unregister();
