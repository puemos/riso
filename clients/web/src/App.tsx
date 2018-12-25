import React from "react";
import { connect } from "react-redux";
import LoginForm from "./modules/auth/components/LoginForm";
import PositionsList from "./modules/positions/components/PositionsList";
import { getIsAuthenticated } from "./modules/auth/selectors";
import { RootState } from "./store/root-reducer";

type Props = {
  isAuthenticated: boolean;
};

function App(props: Props) {
  const { isAuthenticated } = props;
  return (
    <div>
      {isAuthenticated.toString()}

      <LoginForm />
      {isAuthenticated && <PositionsList />}
    </div>
  );
}

const mapStateToProps = (state: RootState) => ({
  isAuthenticated: getIsAuthenticated(state.auth)
});

export default connect(mapStateToProps)(App);
