import { createStandardAction, ActionType } from "typesafe-actions";

export const LOGGED_IN = "auth/LOGGED_IN";
export const LOGGED_OUT = "auth/LOGGED_OUT";

export const AuthActions = {
  loggedIn: createStandardAction(LOGGED_IN)(),
  loggedOut: createStandardAction(LOGGED_OUT)()
};

export type AuthActions = ActionType<typeof AuthActions>;
