import React from "react";
import { ApolloProvider } from "react-apollo";
import { ApolloProvider as ApolloProviderHooks } from "react-apollo-hooks";
import ReactDOM from "react-dom";
import { client } from "./apolloClient";
import LoginForm from "./components/LoginForm";
import * as serviceWorker from "./serviceWorker";
import PositionList from "./components/PositionsList";

const App = () => (
  <ApolloProvider client={client}>
    <ApolloProviderHooks client={client}>
      <LoginForm />
      <PositionList />
    </ApolloProviderHooks>
  </ApolloProvider>
);
ReactDOM.render(<App />, document.getElementById("root"));

serviceWorker.unregister();
