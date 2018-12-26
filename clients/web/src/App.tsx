import { Router } from "@reach/router";
import React from "react";
import { connect } from "react-redux";
import { getIsAuthenticated } from "./modules/auth/selectors";
import { RootState } from "./store/root-reducer";
import LoginView from "./views/LoginView";
import PositionsView from "./views/PositionsView";

const NotFound: React.SFC<{ default: boolean }> = () => (
  <p>Sorry, nothing here</p>
);

type Props = {
  isAuthenticated: boolean;
};

function App(props: Props) {
  const { isAuthenticated } = props;
  return (
    <>
      <Router>
        <LoginView path="/login" />
        {isAuthenticated && <PositionsView path="/positions" />}
        <NotFound default />
      </Router>
    </>
  );
}

const mapStateToProps = (state: RootState) => ({
  isAuthenticated: getIsAuthenticated(state.auth)
});

export default connect(mapStateToProps)(App);
