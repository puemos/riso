import { InMemoryCache } from "apollo-cache-inmemory";
import { ApolloClient } from "apollo-client";
import { setContext } from "apollo-link-context";
import { createHttpLink } from "apollo-link-http";

const httpLink = createHttpLink({
  uri: process.env.REACT_APP_API_URL
});

const cache = new InMemoryCache();

const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem("token");
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : ""
    }
  };
});

export const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache
});
