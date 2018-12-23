import { ApolloClient } from "apollo-client";
import { InMemoryCache } from "apollo-cache-inmemory";
import { setContext } from "apollo-link-context";
import { createHttpLink } from "apollo-link-http";
import React from "react";
import ReactDOM from "react-dom";
import LoginForm from "./components/LoginForm";
import * as serviceWorker from "./serviceWorker";
import { ApolloProvider } from "react-apollo";

const httpLink = createHttpLink({
  uri: process.env.REACT_APP_API_URL
});

const authLink = setContext((_, { headers }) => {
  // get the authentication token from local storage if it exists
  const token = localStorage.getItem("token");
  // return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : ""
    }
  };
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
});

const App = () => (
  <ApolloProvider client={client}>
    <LoginForm />
  </ApolloProvider>
);
ReactDOM.render(<App />, document.getElementById("root"));

serviceWorker.unregister();
