import { Router } from "@reach/router";
import gql from "graphql-tag";
import React, { useEffect } from "react";
import { useQuery } from "react-apollo-hooks";
import { AuthActions } from "./features/auth/actions";
import { getIsAuthenticated } from "./features/auth/selectors";
import { CurrentUserQuery, CurrentUserVariables } from "./generated/types";
import { useReduxAction } from "./redux/hooks/use-redux-action";
import { useReduxState } from "./redux/hooks/use-redux-state";
import LoginView from "./views/LoginView";
import PositionBoardView from "./views/PositionBoardView";
import PositionsView from "./views/PositionsView";
import ApplicantView from "./views/ApplicantView";

const NotFound: React.SFC<{ default: boolean }> = () => (
  <p>Sorry, nothing here</p>
);

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

function App() {
  const { data, loading, errors } = useQuery<
    CurrentUserQuery,
    CurrentUserVariables
  >(CURRENT_USER_QUERY, {
    suspend: false,
    fetchPolicy: "network-only"
  });
  const loggedIn = useReduxAction(AuthActions.loggedIn);
  const isAuthenticated = useReduxState(getIsAuthenticated);
  useEffect(() => {
    if (data.currentUser) {
      loggedIn();
    }
  });
  if (errors) {
    return <div>super</div>;
  }
  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <Router>
      <LoginView path="/login" />
      {isAuthenticated && <ApplicantView path="/applicant/:id" />}
      {isAuthenticated && <PositionsView path="/positions" />}
      {isAuthenticated && <PositionBoardView path="/positions/:id" />}
      <NotFound default />
    </Router>
  );
}

export default App;
