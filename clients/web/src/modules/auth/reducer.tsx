import * as fromActions from "./actions";
import { Reducer } from "redux";

const initialState = {
  isAuthenticated: false
};

export type AuthState = typeof initialState;

export const authReducer: Reducer<AuthState, fromActions.AuthActions> = (
  state = initialState,
  action
) => {
  switch (action.type) {
    case fromActions.LOGGED_IN:
      return {
        isAuthenticated: true
      };
    case fromActions.LOGGED_OUT:
      return {
        isAuthenticated: false
      };
  }
  return initialState;
};
