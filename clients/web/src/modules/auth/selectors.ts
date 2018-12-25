import { AuthState } from "./reducer";

export const getIsAuthenticated = (state: AuthState) => state.isAuthenticated;
