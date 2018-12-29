import { Router } from "@reach/router";
import React, { useEffect } from "react";
import { connect } from "react-redux";
import { RootState } from "./store/root-reducer";
import LoginView from "./views/LoginView";
import PositionBoardView from "./views/PositionBoardView";
import PositionsView from "./views/PositionsView";
import { getIsAuthenticated } from "./features/auth/selectors";
import gql from "graphql-tag";
import { useQuery } from "react-apollo-hooks";
import { CurrentUserQuery, CurrentUserVariables } from "./generated/types";
import { AuthActions } from "./features/auth/actions";
import store from "./store/store";

const NotFound: React.SFC<{ default: boolean }> = () => (
  <p>Sorry, nothing here</p>
);

type Props = {
  isAuthenticated: boolean;
};

const CURRENT_USER_QUERY = gql`
  query currentUser {
    currentUser {
      email
      id
      name
      organizations {
        id
        name
      }
    }
  }
`;

function App(props: Props) {
  const { data, loading } = useQuery<CurrentUserQuery, CurrentUserVariables>(
    CURRENT_USER_QUERY,
    {
      suspend: false
    }
  );
  useEffect(() => {
    if (data.currentUser) {
      store.dispatch(AuthActions.loggedIn());
    }
  });

  if (loading) {
    return <div>Loading...</div>;
  }
  const { isAuthenticated } = props;

  return (
    <Router>
      <LoginView path="/login" />
      {isAuthenticated && <PositionBoardView path="/position/:id" />}
      {isAuthenticated && <PositionsView path="/positions" />}
      <NotFound default />
    </Router>
  );
}

const mapStateToProps = (state: RootState) => ({
  isAuthenticated: getIsAuthenticated(state.auth)
});

export default connect(mapStateToProps)(App);
