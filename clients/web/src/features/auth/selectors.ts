import { RootState } from "../../redux/root-reducer";

export const getIsAuthenticated = (state: RootState) =>
  state.auth.isAuthenticated;
